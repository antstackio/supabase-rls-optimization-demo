# Supabase RLS Optimization Demo

A multi-organization project management database with Row Level Security (RLS) to ensure secure data isolation. Organizations manage their own projects and can share projects or assign tasks across organizations, enabling controlled collaboration while maintaining strict access control.

## Description

This repository contains files to setup a Supabase project to recreate the results mentioned in blog. It includes:

- Custom JWT token generation for RLS authorization.
- SQL migration scripts to set up the database schema, extensions, and RLS policies.
- Configuration files for Supabase services.

## Prerequisites

- Node.js and npm installed
- Supabase account and project
- Supabase CLI installed

## Setup

1. Clone the repository:

```sh
git clone https://github.com/antstackio/supabase-rls-optimization-demo.git
cd supabase-rls-optimization-demo
```

2. Install dependencies:

```sh
npm install
```

3. Create a `.env` file based on `.env.example` and set your JWT secret:

```sh
cp .env.example .env
# Edit .env to set your JWT_SECRET
```

4. Generate a JWT token (optional):

```sh
npm run gen-token
```

## Configuring and Run Supabase

1. Initialize Supabase in your project directory:

```sh
supabase init
```

2. Start the Supabase local development environment:

```sh
supabase start
```

## Usage

- Use the generated JWT token to authenticate API requests.
- Manage projects, tasks, tenants, and users with secure RLS policies.
