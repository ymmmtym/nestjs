#==================================================
# Build Layer
FROM node:14-slim as build

WORKDIR /app

COPY package.json yarn.lock ./
# COPY package.json package-lock.json ./

RUN yarn install --non-interactive --frozen-lockfile
# RUN cpm ci

COPY . .

RUN yarn build
# RUN npm run build

#==================================================
# Package install Layer
FROM node:14-slim as node_modules

WORKDIR /app

COPY package.json yarn.lock ./
# COPY package.json package-lock.json ./

RUN yarn install --non-interactive --frozen-lockfile --prod
# RUN cpm ci --only=production

#==================================================
# Run Layer
FROM gcr.io/distroless/nodejs:14

WORKDIR /app

ENV NODE_ENV=production

COPY --from=build /app/dist /app/dist
COPY --from=node_modules /app/node_modules /app/node_modules

CMD ["dist/main"]
