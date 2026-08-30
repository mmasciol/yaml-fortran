#!/usr/bin/env node
import { App } from 'aws-cdk-lib';
import { YamlFortranSiteStack } from '../lib/yaml-fortran-site-stack';

const app = new App();

function requiredContext(name: string): string {
  const value = app.node.tryGetContext(name);

  if (typeof value !== 'string' || value.length === 0) {
    throw new Error(`Missing required CDK context value: ${name}`);
  }

  return value;
}

const domainName = requiredContext('domainName');
const siteSubdomain = requiredContext('siteSubdomain');
const githubOwner = requiredContext('githubOwner');
const githubRepo = requiredContext('githubRepo');
const githubBranch = requiredContext('githubBranch');
const replaceExistingDnsRecordsContext = app.node.tryGetContext(
  'replaceExistingDnsRecords',
);

new YamlFortranSiteStack(app, 'YamlFortranSiteStack', {
  domainName,
  siteSubdomain,
  githubOwner,
  githubRepo,
  githubBranch,
  githubSubjectClaim: `repo:${githubOwner}/${githubRepo}:ref:refs/heads/${githubBranch}`,
  replaceExistingDnsRecords:
    replaceExistingDnsRecordsContext === true ||
    replaceExistingDnsRecordsContext === 'true',
  env: {
    account: process.env.CDK_DEFAULT_ACCOUNT,
    region: 'us-east-1',
  },
});
