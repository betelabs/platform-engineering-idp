import React from 'react';
import Grid from '@material-ui/core/Grid';
import {
  HomePageToolkit,
  HomePageCompanyLogo,
  HomePageStarredEntities,
  TemplateBackstageLogo,
} from '@backstage/plugin-home';
import { Content, Page, InfoCard } from '@backstage/core-components';
import { HomePageSearchBar } from '@backstage/plugin-search';

export const HomePage = () => (
  <Page themeId="home">
    <Content>
      <Grid container spacing={3} alignItems="stretch">
        <Grid item xs={12} md={6}>
          <HomePageCompanyLogo logo={<TemplateBackstageLogo />} />
        </Grid>
        <Grid item xs={12} md={6}>
          <HomePageSearchBar />
        </Grid>
        <Grid item xs={12} md={6}>
          <InfoCard title="Quick Links">
            <HomePageToolkit
              tools={[
                { label: 'ArgoCD',    url: process.env.ARGOCD_BASE_URL    || '#', icon: <span>🚀</span> },
                { label: 'Grafana',   url: process.env.GRAFANA_BASE_URL   || '#', icon: <span>📊</span> },
                { label: 'GitHub',    url: 'https://github.com/your-org',          icon: <span>🐙</span> },
                { label: 'Runbooks',  url: '/docs/default/system/developer-platform', icon: <span>📖</span> },
              ]}
            />
          </InfoCard>
        </Grid>
        <Grid item xs={12} md={6}>
          <HomePageStarredEntities />
        </Grid>
      </Grid>
    </Content>
  </Page>
);
