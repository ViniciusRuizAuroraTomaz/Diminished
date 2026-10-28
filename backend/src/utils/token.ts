import  jwt, { JwtPayload }  from "jsonwebtoken"
import { randomBytes, createHash } from "node:crypto";

export function signToken(payload : JwtPayload) : String{
    const token = jwt.sign(payload, process.env.JWT_SECRET!, {
        expiresIn: "15m"
    })

    return token
}

export function verifyToken(token: string) : string | JwtPayload {
    const decodedToken = jwt.verify(token ,process.env.JWT_SECRET!) as JwtPayload
    return decodedToken
}

export function generateRefreshToken() {
  return randomBytes(32).toString("hex");
}

export function hashToken(token: string) {
  return createHash("sha256")
    .update(token)
    .digest("hex");
}