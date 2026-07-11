# Foundation website

This is a dependency-free static site describing the Apple Development Foundation package. The site deliberately lives outside the Swift package targets and does not change package source, products, or module dependencies. Its summaries are derived from the repository README and `Documentation/` source-of-truth files.

## Preview locally

From the repository root:

```bash
python3 -m http.server 4173 --directory Website
```

Open <http://localhost:4173>.

## Deploy

Publish the contents of `Website/` as the document root on any static host, including GitHub Pages, Cloudflare Pages, Netlify, or a simple web server. No build step, runtime, environment variables, or external assets are required.

Run `./Scripts/verify-website.sh` before publishing to check the required files and key documentation anchors.
