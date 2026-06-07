import { createRouter } from '@backstage/plugin-scaffolder-backend';
import { createBuiltinActions } from '@backstage/plugin-scaffolder-backend';
import { ScmIntegrations } from '@backstage/integration';
import { Router } from 'express';
import type { PluginEnvironment } from '../types';

export default async function createPlugin(
  env: PluginEnvironment,
): Promise<Router> {
  const integrations = ScmIntegrations.fromConfig(env.config);
  const builtinActions = createBuiltinActions({
    integrations,
    config: env.config,
    catalogClient: env.catalogClient,
    reader: env.reader,
  });

  return await createRouter({
    actions: [...builtinActions],
    logger: env.logger,
    config: env.config,
    database: env.database,
    reader: env.reader,
    catalogClient: env.catalogClient,
    identity: env.identity,
  });
}
