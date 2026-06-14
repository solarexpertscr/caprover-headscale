# CapRover Headscale Deployment

This repository contains a ready-to-deploy Headscale server configuration for CapRover.

## Deployment Instructions

1. **Create a new app** in your CapRover dashboard (e.g., `headscale`).
2. Go to the **Deployment** tab.
3. Under **Method 4: Deploy from GitHub / GitLab**, connect this repository.
4. In the **App Configs** > **HTTP Settings** tab, disable "Force HTTPS" *temporarily* if you haven't set up a domain yet, but it is highly recommended to enable it and provide a valid domain (e.g., `headscale.yourdomain.com`).
5. **Important: Environment Variables**
   Add the following environment variables in the CapRover dashboard (**App Configs** > **App Specific Environmental Variables**):
   - `HEADSCALE_SERVER_URL`: `https://headscale.yourdomain.com` (replace with your actual domain)
   - `HEADSCALE_BASE_DOMAIN`: `yourdomain.com` (replace with your base domain)
   - `HEADSCALE_OIDC_CLIENT_ID`: *(Optional, if using OIDC)*
   - `HEADSCALE_OIDC_CLIENT_SECRET`: *(Optional, if using OIDC)*
6. Click **Save & Update**.
7. **Persistent Data**: Make sure to map `/var/lib/headscale` as a persistent directory in CapRover (App Configs > Persistent Directories).
8. **Port Mapping**: Headscale listens on `8080` by default in this Dockerfile. CapRover will handle routing to this port.

## Post-Deployment Setup

1. Access your server's terminal (e.g., via CapRover's web terminal, or SSH into the server and run `docker exec -it srv-captain--<app-name> /bin/sh`).
2. Create your first user:
   ```bash
   headscale users create your-username
   ```
3. Generate a pre-auth key for your clients:
   ```bash
   headscale preauthkeys create --user your-username
   ```
4. On your client machine, point the Tailscale client to your new server:
   ```bash
   tailscale up --login-server https://headscale.yourdomain.com
   ```
   Or use the pre-auth key:
   ```bash
   tailscale up --login-server https://headscale.yourdomain.com --authkey <your-preauth-key>
   ```

## Files Included

- `captain-definition`: Tells CapRover how to build the app.
- `Dockerfile`: Based on the official Headscale image, adds config files.
- `config.yaml`: Default Headscale configuration, utilizing environment variables.
- `acl.hujson`: Default permissive ACL policy (adjust for production security).
