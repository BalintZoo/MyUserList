//
//  UserList.swift
//  MyUserList
//
//  Created by Zoltán Bálint on 15.03.2024.
//

// Dragon.swift

import Foundation

// MARK: - Dragon
struct Dragon: Codable {
    let heatShield: HeatShield
    let launchPayloadMass: Mass
    let launchPayloadVol: Volume
    let returnPayloadMass: Mass
    let returnPayloadVol: Volume
    let pressurizedCapsule: PressurizedCapsule
    let trunk: Trunk
    let heightWTrunk: Dimension
    let diameter: Dimension
    let firstFlight: String
    let flickrImages: [String]
    let name, type: String
    let active: Bool
    let crewCapacity, sidewallAngleDeg, orbitDurationYr, dryMassKg: Int
    let dryMassLb: Int
    let thrusters: [Thruster]
    let wikipedia, description, id: String

    enum CodingKeys: String, CodingKey {
        case heatShield = "heat_shield"
        case launchPayloadMass = "launch_payload_mass"
        case launchPayloadVol = "launch_payload_vol"
        case returnPayloadMass = "return_payload_mass"
        case returnPayloadVol = "return_payload_vol"
        case pressurizedCapsule = "pressurized_capsule"
        case trunk
        case heightWTrunk = "height_w_trunk"
        case diameter
        case firstFlight = "first_flight"
        case flickrImages = "flickr_images"
        case name, type, active
        case crewCapacity = "crew_capacity"
        case sidewallAngleDeg = "sidewall_angle_deg"
        case orbitDurationYr = "orbit_duration_yr"
        case dryMassKg = "dry_mass_kg"
        case dryMassLb = "dry_mass_lb"
        case thrusters, wikipedia, description, id
    }
}

// MARK: - HeatShield
struct HeatShield: Codable {
    let material: String
    let sizeMeters: Double
    let tempDegrees: Int
    let devPartner: String

    enum CodingKeys: String, CodingKey {
        case material
        case sizeMeters = "size_meters"
        case tempDegrees = "temp_degrees"
        case devPartner = "dev_partner"
    }
}

// MARK: - Mass
struct Mass: Codable {
    let kg: Int
    let lb: Int
}

// MARK: - Volume
struct Volume: Codable {
    let cubicMeters: Int
    let cubicFeet: Int

    enum CodingKeys: String, CodingKey {
        case cubicMeters = "cubic_meters"
        case cubicFeet = "cubic_feet"
    }
}

// MARK: - Dimension
struct Dimension: Codable {
    let meters: Double
    let feet: Double
}

// MARK: - PressurizedCapsule
struct PressurizedCapsule: Codable {
    let payloadVolume: Volume

    enum CodingKeys: String, CodingKey {
        case payloadVolume = "payload_volume"
    }
}

// MARK: - Trunk
struct Trunk: Codable {
    let trunkVolume: Volume
    let cargo: Cargo

    enum CodingKeys: String, CodingKey {
        case trunkVolume = "trunk_volume"
        case cargo
    }
}

// MARK: - Cargo
struct Cargo: Codable {
    let solarArray: Int
    let unpressurizedCargo: Bool

    enum CodingKeys: String, CodingKey {
        case solarArray = "solar_array"
        case unpressurizedCargo = "unpressurized_cargo"
    }
}

// MARK: - Thruster
struct Thruster: Codable {
    let type: String
    let amount, pods: Int
    let fuel1, fuel2: String
    let isp: Int
    let thrust: Thrust

    enum CodingKeys: String, CodingKey {
        case type, amount, pods
        case fuel1 = "fuel_1"
        case fuel2 = "fuel_2"
        case isp, thrust
    }
}

// MARK: - Thrust
struct Thrust: Codable {
    let kN: Double
    let lbf: Double
}
