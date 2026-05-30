/**
 * Spark Backend - Cloudflare Workers
 *
 * Responsibilities:
 * - Proxy all AI calls through Cloudflare AI Gateway (easy model switching)
 * - Store and retrieve child profiles, progress, LearnerProfile (AI memory), and collected Echoes
 * - Provide structured recommendations to the mobile app
 *
 * The mobile app is local-first. This backend is the source of truth for long-term memory and AI.
 */

export interface Env {
  DB: D1Database;
  // KV?: KVNamespace;
  // AI_GATEWAY_TOKEN?: string;
}

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    const url = new URL(request.url);

    // Basic health check
    if (url.pathname === '/health') {
      return new Response(JSON.stringify({ status: 'ok', service: 'spark-backend' }), {
        headers: { 'Content-Type': 'application/json' },
      });
    }

    // TODO: AI Gateway proxy route
    // if (url.pathname.startsWith('/ai')) { ... }

    // TODO: Profile + progress routes
    // if (url.pathname.startsWith('/profiles')) { ... }

    return new Response('Spark Backend - Not yet implemented', { status: 404 });
  },
};
