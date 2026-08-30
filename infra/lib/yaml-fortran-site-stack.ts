import {
  CfnOutput,
  Duration,
  RemovalPolicy,
  Stack,
  StackProps,
  Aws,
} from 'aws-cdk-lib';
import * as acm from 'aws-cdk-lib/aws-certificatemanager';
import * as cloudfront from 'aws-cdk-lib/aws-cloudfront';
import * as origins from 'aws-cdk-lib/aws-cloudfront-origins';
import * as iam from 'aws-cdk-lib/aws-iam';
import * as route53 from 'aws-cdk-lib/aws-route53';
import * as targets from 'aws-cdk-lib/aws-route53-targets';
import * as s3 from 'aws-cdk-lib/aws-s3';
import { Construct } from 'constructs';

export interface YamlFortranSiteStackProps extends StackProps {
  readonly domainName: string;
  readonly siteSubdomain: string;
  readonly githubOwner: string;
  readonly githubRepo: string;
  readonly githubBranch: string;
  readonly githubSubjectClaim: string;
  readonly githubOidcProviderArn?: string;
  readonly replaceExistingDnsRecords: boolean;
}

export class YamlFortranSiteStack extends Stack {
  constructor(scope: Construct, id: string, props: YamlFortranSiteStackProps) {
    super(scope, id, props);

    const siteDomain = `${props.siteSubdomain}.${props.domainName}`;

    const hostedZone = route53.HostedZone.fromLookup(this, 'HostedZone', {
      domainName: props.domainName,
    });

    const siteBucket = new s3.Bucket(this, 'SiteBucket', {
      blockPublicAccess: s3.BlockPublicAccess.BLOCK_ALL,
      encryption: s3.BucketEncryption.S3_MANAGED,
      enforceSSL: true,
      removalPolicy: RemovalPolicy.RETAIN,
      versioned: true,
    });

    const certificate = new acm.Certificate(this, 'SiteCertificate', {
      domainName: siteDomain,
      subjectAlternativeNames: [props.domainName],
      validation: acm.CertificateValidation.fromDns(hostedZone),
    });

    const distribution = new cloudfront.Distribution(this, 'Distribution', {
      certificate,
      defaultBehavior: {
        allowedMethods: cloudfront.AllowedMethods.ALLOW_GET_HEAD_OPTIONS,
        cachedMethods: cloudfront.CachedMethods.CACHE_GET_HEAD_OPTIONS,
        compress: true,
        origin: origins.S3BucketOrigin.withOriginAccessControl(siteBucket),
        viewerProtocolPolicy: cloudfront.ViewerProtocolPolicy.REDIRECT_TO_HTTPS,
      },
      defaultRootObject: 'index.html',
      domainNames: [siteDomain, props.domainName],
      errorResponses: [
        {
          httpStatus: 403,
          responseHttpStatus: 404,
          responsePagePath: '/404.html',
          ttl: Duration.minutes(5),
        },
        {
          httpStatus: 404,
          responseHttpStatus: 404,
          responsePagePath: '/404.html',
          ttl: Duration.minutes(5),
        },
      ],
      minimumProtocolVersion: cloudfront.SecurityPolicyProtocol.TLS_V1_2_2021,
    });

    const cloudFrontTarget = route53.RecordTarget.fromAlias(
      new targets.CloudFrontTarget(distribution),
    );
    const dnsReplacementOptions = props.replaceExistingDnsRecords
      ? { deleteExisting: true }
      : {};

    new route53.ARecord(this, 'ApexAliasRecord', {
      ...dnsReplacementOptions,
      target: cloudFrontTarget,
      zone: hostedZone,
    });

    new route53.AaaaRecord(this, 'ApexIpv6AliasRecord', {
      ...dnsReplacementOptions,
      target: cloudFrontTarget,
      zone: hostedZone,
    });

    new route53.ARecord(this, 'WwwAliasRecord', {
      ...dnsReplacementOptions,
      recordName: props.siteSubdomain,
      target: cloudFrontTarget,
      zone: hostedZone,
    });

    new route53.AaaaRecord(this, 'WwwIpv6AliasRecord', {
      ...dnsReplacementOptions,
      recordName: props.siteSubdomain,
      target: cloudFrontTarget,
      zone: hostedZone,
    });

    const githubOidcProviderArn =
      props.githubOidcProviderArn ??
      `arn:${Aws.PARTITION}:iam::${Aws.ACCOUNT_ID}:oidc-provider/token.actions.githubusercontent.com`;
    const githubOidcProvider =
      iam.OpenIdConnectProvider.fromOpenIdConnectProviderArn(
        this,
        'GitHubOidcProvider',
        githubOidcProviderArn,
      );

    const deployRole = new iam.Role(this, 'GitHubSiteDeployRole', {
      assumedBy: new iam.WebIdentityPrincipal(
        githubOidcProvider.openIdConnectProviderArn,
        {
          StringEquals: {
            'token.actions.githubusercontent.com:aud': 'sts.amazonaws.com',
            'token.actions.githubusercontent.com:sub': props.githubSubjectClaim,
          },
        },
      ),
      description: `Deploy ${siteDomain} from ${props.githubOwner}/${props.githubRepo}:${props.githubBranch}`,
    });

    deployRole.addToPolicy(
      new iam.PolicyStatement({
        actions: ['s3:ListBucket'],
        resources: [siteBucket.bucketArn],
      }),
    );
    deployRole.addToPolicy(
      new iam.PolicyStatement({
        actions: ['s3:DeleteObject', 's3:GetObject', 's3:PutObject'],
        resources: [siteBucket.arnForObjects('*')],
      }),
    );
    deployRole.addToPolicy(
      new iam.PolicyStatement({
        actions: ['cloudfront:CreateInvalidation'],
        resources: [
          `arn:aws:cloudfront::${this.account}:distribution/${distribution.distributionId}`,
        ],
      }),
    );

    new CfnOutput(this, 'SiteUrl', {
      value: `https://${siteDomain}`,
    });
    new CfnOutput(this, 'ApexUrl', {
      value: `https://${props.domainName}`,
    });
    new CfnOutput(this, 'SiteBucketName', {
      value: siteBucket.bucketName,
    });
    new CfnOutput(this, 'CloudFrontDistributionId', {
      value: distribution.distributionId,
    });
    new CfnOutput(this, 'CloudFrontDomainName', {
      value: distribution.distributionDomainName,
    });
    new CfnOutput(this, 'GitHubSiteDeployRoleArn', {
      value: deployRole.roleArn,
    });
  }
}
