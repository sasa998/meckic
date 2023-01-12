FROM node:16-alpine AS builder
ARG environment
RUN addgroup --system --gid 1001 nodejs && \
     adduser --system --uid 1001 nextjs && \
     apk add --no-cache libc6-compat && \
     mkdir -p /app && chown -R nextjs:nodejs /app
WORKDIR /app
COPY . .
ENV NEXT_TELEMETRY_DISABLED 1
RUN yarn install && yarn build:$environment
USER nextjs
EXPOSE 8000
CMD ["next", "start"]