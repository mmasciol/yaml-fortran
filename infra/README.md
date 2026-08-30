# Infrastructure

Redeploy the CDK stack from this directory:

```bash
npm install
npx cdk diff
npx cdk deploy
```

If the environment has not been bootstrapped for CDK yet:

```bash
npx cdk bootstrap
```

The stack reads its defaults from `cdk.json`. Generated CDK context and output files should not be committed.
