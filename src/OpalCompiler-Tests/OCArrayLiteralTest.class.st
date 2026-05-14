Class {
	#name : 'OCArrayLiteralTest',
	#superclass : 'TestCase',
	#category : 'OpalCompiler-Tests-FromOld',
	#package : 'OpalCompiler-Tests',
	#tag : 'FromOld'
}

{ #category : 'tests' }
OCArrayLiteralTest >> byteArray [
	
	^ #[2r1010 8r333 16rFF]
	
]

{ #category : 'tests' }
OCArrayLiteralTest >> byteArrayEmpty [

	^ #[]
	
]

{ #category : 'tests' }
OCArrayLiteralTest >> byteArrayLiteral [

	^ #[ 1 2 3 4 ]
]

{ #category : 'tests' }
OCArrayLiteralTest >> byteArrayLong [
	 ^ #[  0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255 ]
	
]

{ #category : 'tests' }
OCArrayLiteralTest >> byteArrayRange [
	
	 ^ #[ 0 255 ]
	
]

{ #category : 'tests' }
OCArrayLiteralTest >> byteArrayWithinArray [

	 ^ #( #[1] #[2] )
]

{ #category : 'running' }
OCArrayLiteralTest >> compile: methodSourceCode [

	^ OpalCompiler new
		source: methodSourceCode;
		compileOrFail	
]

{ #category : 'tests' }
OCArrayLiteralTest >> literalArrayLongHavingAnotherArrayLong [

 	^ {   . 1 . 2 . 3 . 4 . 5 . 6 . 7 . 8 . 9 . 10 . 11 . 12 . 13 . 14 . 15 . 16 . 17 . 18 . 19 . 20 . 21 . 22 . 23 . 24 . 25 . 26 . 27 . 28 . 29 . 30 . 31 .  {   . 1 . 2 . 3 . 4 . 5 . 6 . 7 . 8 . 9 . 10 . 11 . 12 . 13 . 14 . 15 . 16 . 17 . 18 . 19 . 20 . 21 . 22 . 23 . 24 . 25 . 26 . 27 . 28 . 29 . 30 . 31 . 32 } }
]

{ #category : 'tests' }
OCArrayLiteralTest >> reservedIdentifiers [

	^ #(nil true false)
]

{ #category : 'tests' }
OCArrayLiteralTest >> symbols [
	
	 ^ #(#nil #true #false #'nil' #'true' #'false').
	
]

{ #category : 'tests' }
OCArrayLiteralTest >> testByteArrayBase [
	
	| array | 
	array := self byteArray.
	self assert: (array isKindOf: ByteArray).
	self assert: array size equals: 3.
	self assert: array first equals: 10.
	self assert: array second equals: 219.
	self assert: array last equals: 255
]

{ #category : 'tests' }
OCArrayLiteralTest >> testByteArrayEmpty [

	| array |
	array := self byteArrayEmpty.
	self assert: (array isKindOf: ByteArray).
	self assertEmpty: array
]

{ #category : 'tests' }
OCArrayLiteralTest >> testByteArrayLiteral [

	| array |
	array := self byteArrayLiteral.
	self assert: array equals: array.
	self assert: array identicalTo: array
]

{ #category : 'tests' }
OCArrayLiteralTest >> testByteArrayLong [
	
	| array |
	array := self byteArrayLong.
	self assert: ( array isKindOf: ByteArray).
	self assert: array size equals: 256.
	0 to: 255 do: [ :index | self assert: (array at: index + 1) equals: index ]
]

{ #category : 'tests' }
OCArrayLiteralTest >> testByteArrayRange [
	
	| array |
	array := self byteArrayRange.
	self assert: ( array isKindOf: ByteArray).
	self assert:  array size equals: 2.
	self assert:  array first equals: 0.
	self assert:  array last equals: 255
]

{ #category : 'tests' }
OCArrayLiteralTest >> testByteArrayWithinArray [

	| array |
	array := self byteArrayWithinArray.
	self assert: (array isKindOf: Array).
	self assert: array size equals: 2.
	self assert: (array first isKindOf: ByteArray).
	self assert: array first first equals: 1.
	self assert: (array last isKindOf: ByteArray).
	self assert:  array last first equals: 2
]

{ #category : 'tests' }
OCArrayLiteralTest >> testLiteralArrayLongHavingAnotherArrayLong [

	| array |
	
	array := self literalArrayLongHavingAnotherArrayLong.
	
	self assert: ( array isKindOf: Array).
	self assert: array size equals: 32.
	1 to: 31 do: [ :index | self assert: (array at: index) equals: index ].
	1 to: 32 do: [ :index | self assert: ((array at: 32) at: index) equals: index ].
]

{ #category : 'tests' }
OCArrayLiteralTest >> testReservedIdentifiers [

	| array |
	array := self reservedIdentifiers.
	self 
		assert: array 
		equals: {nil . true . false}
]

{ #category : 'tests' }
OCArrayLiteralTest >> testSymbols [
	
	| array |
	array := self symbols.
	
	self 
		assert: array 
		equals: { #nil . #true . #false . #nil . #true . #false }
]
