//
//  WebServiceConstants.swift
//  ApplaudoTMDBApp
//
//  Created by Gabriel Rico on 5/2/21.
//

import Foundation

enum ApiResponseType {
    case Default
    case LoginResponse
    case SignupEmailValidationResponse
    case SignupPhoneValidationResponse
    case ValidateReferralCode
    case SendOTP
    case SignUpResponse
    case RideBookingCreate
    case RideBookingCancel
    case GetRideBookingCancelReason
    case RideBookingCancellingWithReasons
    case ShipmentDetailsCaculation
    case ShipmentBookingCreate
}

enum HTTPResponseCode: Int {
    case Default = 0
    case Success = 200
    case BadRequest = 400
    case Unauthorized = 401
    case PaymentRequired = 402
    case Forbidden = 403
    case NotFound = 404
    case NotAllowed = 405
    case NotAcceptable = 406
    case UnKownError = 407
    case Timeout = 408
    case Conflict = 409
    case Gone = 410
    case LengthRequired = 411
    case PreconditionFailed = 412
    case RequestEntityTooLarge = 413
    case NewError = 421
    case TooManyRequests = 429
    case WalletUnfunded = 458
    case InternalServerError = 500
    case Unknown = 1000
}
