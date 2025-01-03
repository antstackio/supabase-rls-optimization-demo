const jwt = require("jsonwebtoken");
require("dotenv").config();
/**
 * Generates a custom JWT token for Supabase Row Level Security (RLS) authorization
 *
 * @description Creates a signed JWT containing claims that work with custom RLS policies.
 * The token supports three authorization types (ADMIN, ORGANIZATION, USER)
 *
 * @param {string} type - The authorization type: 'ADMIN', 'ORGANIZATION', or 'USER'
 * @param {number[]} tenantIds - Array of tenant IDs the token will have access to
 * @returns {string} The generated JWT string
 *
 * @example
 * const token = generateToken('ORGANIZATION', [1, 2]);
 *
 * @throws {Error} If JWT_SECRET environment variable is not configured
 * @throws {Error} If type parameter is not one of the allowed values
 * @throws {Error} If tenantIds is not an array of numbers
 *
  * @note The JWT secret should be obtained from Supabase Dashboard:
 *       Project Settings > API > JWT Secret
 */
function generateToken(type, tenantIds) {
  let jwtSecret = process.env.JWT_SECRET;
  if (!jwtSecret) {
    throw new Error("JWT_SECRET environment variable is not configured");
  }

  const validTypes = ["ADMIN", "ORGANIZATION", "USER"];
  if (!validTypes.includes(type)) {
    throw new Error(`Type must be one of: ${validTypes.join(", ")}`);
  }

  if (
    !Array.isArray(tenantIds) ||
    !tenantIds.every((id) => typeof id === "number")
  ) {
    throw new Error("tenantIds must be an array of numbers");
  }

  var token = jwt.sign(
    {
      type: type,
      tenant_ids: `{${tenantIds.join(",")}}`, // Formats array for Postgres
      role: "authenticated",
    },
    jwtSecret,
    {
      algorithm: "HS256",
      // optional expire
    }
  );

  console.log("token", token);
  return token;
}

 generateToken('ORGANIZATION', [2, 1]);