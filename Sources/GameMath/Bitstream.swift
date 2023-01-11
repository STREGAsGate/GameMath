/**
 * Copyright (c) 2023 Dustin Collins (Strega's Gate)
 * All Rights Reserved.
 * Licensed under Apache License v2.0
 *
 * http://stregasgate.com
 */

public struct BitStream {
    private let bytes: Any
    private var byteOffset: Int {offset / 8}
    private var bitOffset: Int {offset % 8}
    private var offset: Int = 0
    
    /**
     Create a new BitStream
     - parameter bytes: The data to read bits from.
     */
    public init(_ bytes: Any) {
        self.bytes = bytes
    }
    
    /**
     Get a bit from an index
     - parameter index: The index of the desired bit
     - returns: A Bool representing the bit. true for 1, false for 0.
     */
    public subscript (index: Int) -> Bool {
        var pointer = bytes
        return withUnsafeBytes(of: &pointer) { bytes in
            let byte = bytes[byteOffset]
            return (byte >> index) % 2 == 1
        }
    }

    /**
     Read bits into a value
     - parameter numBits: The number of bits to read
     - returns: A FixedWidthInteger containing the value of the requestsed bits
     */
    public mutating func readBits<T: FixedWidthInteger>(_ numBits: Int) -> T {
        guard numBits > 0 else {return 0}
        
        var result: [Bool] = []  // result accumulator
        result.reserveCapacity(numBits)
        
        var pointer = bytes
        withUnsafeBytes(of: &pointer) { bytes in
            for _ in 0 ..< numBits {
                let byte = bytes[byteOffset]
                let v = (byte >> bitOffset) % 2 == 1
                result.append(v)
                offset += 1
            }
        }
        
        return T.init(littleEndian: T.init("\(String(result.reversed().map { $0 ? "1" : "0" }))", radix: 2)!)
    }
    
    /**
     Move the current read postion.
     - parameter numBits: The number of bits to move the read position.
     */
    public mutating func seekBits(_ numBits: Int) {
        offset += numBits
    }
}
