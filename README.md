# CapRover Headscale Deployment

This repository contains a ready-to-deploy Headscale server configuration for CapRover.

Pinned to **headscale v0.29.3**. To upgrade, change the tag in the `Dockerfile` and
check the upstream release notes for config changes first — the config schema has
moved in 0.23 (noise key), 0.28 (database block) and 0.29 (`policy.mode`).

## Deployment Instructions

1. **Create a new app** in your CapRover dashboard (e.g., `headscale`).
2. Go to the **Deployment** tab.
3. Under **Method 4: Deploy from GitHub / GitLab**, connect this repository.
4. In the **App Configs** > **HTTP Settings** tab, disable "Force HTTPS" *temporarily* if you haven't set up a domain yet, but it is highly recommended to enable it and provide a valid domain (e.g., `headscale.yourdomain.com`).
5. **Environment Variables (optional)**
   The domain is already set in `config.yaml`. To override it without editing the
   file, set the following in the CapRover dashboard (**App Configs** > **App Specific
   Environmental Variables**) — headscale reads `HEADSCALE_`-prefixed variables and
   they take priority over the config file:
   - `HEADSCALE_SERVER_URL`: e.g. `https://headscale.yourdomain.com`
   - `HEADSCALE_DNS_BASE_DOMAIN`: e.g. `yourdomain.com` (the base domain is read from
     `dns.base_domain`; setting a top-level `base_domain` has no effect)
   - `HEADSCALE_OIDC_CLIENT_ID`: *(Optional, if using OIDC)*
   - `HEADSCALE_OIDC_CLIENT_SECRET`: *(Optional, if using OIDC)*
6. Click **Save & Update**.
7. **Persistent Data & Litestream Backup**: Make sure to map `/var/lib/headscale` as a persistent directory in CapRover (App Configs > Persistent Directories). **Note:** While Litestream provides robust replication to Google Cloud Storage (GCS), keeping the persistent directory is still recommended for immediate local recovery and reducing initial download times on restart.

   **Litestream Configuration (Google Cloud Storage):**
   Add the following environment variables in CapRover (App Configs > App Configs):
   - `LITESTREAM_BUCKET`: Your GCS bucket name (e.g., `my-headscale-backups`)
   - `LITESTREAM_ACCESS_KEY_ID`: Your Google Cloud Storage HMAC Access Key
   - `LITESTREAM_SECRET_ACCESS_KEY`: Your Google Cloud Storage HMAC Secret Key
   
   *Note: If your bucket is in a specific region, you may also need to add `LITESTREAM_REGION` (e.g., `us-central1`), though GCS often defaults correctly or uses the endpoint configuration.*
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

## Access Control

This deployment runs with `policy.mode: database`, which is what
[Headplane](https://github.com/tale/headplane) needs in order to write policies
through the API. In the default `file` mode, `PUT v1/policy` is rejected with
"update is disabled for modes other than 'database'".

The `acl.hujson` file in this repo is the **fallback policy only** — it is used on
first boot, before any policy has been stored in the database. Once you save a
policy in Headplane, the database copy is authoritative. If you edit `acl.hujson`,
change it in Headplane instead.

## Files Included

- `captain-definition`: Tells CapRover how to build the app.
- `Dockerfile`: Based on the official `headscale/headscale:v0.29.3` image, adds config files.
- `config.yaml`: Headscale configuration. Values can be overridden by `HEADSCALE_`
  environment variables in CapRover.
- `acl.hujson`: Fallback ACL policy for first boot only (see Access Control above).
