//
//  ContentView.swift
//
//  Created by Ryo Kuroyanagi on 2024/02/11.
//

import SwiftUI
import RealityKit
import RealityKitContent
import ModelIO
import Foundation

struct ContentView: View {

    var body: some View {
        VStack {
            RealityView { content in
                let scene = Entity()
                content.add(scene)
                
                var vertexes: [SIMD3<Float>] = []
                var normals: [SIMD3<Float>] = []
                
                let r = Float(0.5)
                let segments = 24
                let hRow = Float(0.5)
                let rows = 10
                
                for i in 0...rows {
                    for j in 0...segments-1 {
                        let angle = Float(j) / Float(segments) * 2 * Float.pi
                        let x = r * cos(angle)
                        let z = r * sin(angle)
                        let y = Float(i) * hRow
                        vertexes.append(SIMD3<Float>(Float(x), Float(y), z))
                        normals.append(SIMD3<Float>(sin(angle), 0, cos(angle)))
                    }
                }
                
                var triangles: [UInt32] = []
                for i in 0...rows - 1 {
                    for j in 0...segments - 1 {
                        let n0 = i * segments + j
                        let n1 = j == segments - 1 ? i * segments : n0 + 1
                        let n2 = n0 + segments
                        let n3 = j == segments - 1 ? (i + 1) * segments : n2 + 1
                        triangles.append(UInt32(n0))
                        triangles.append(UInt32(n2))
                        triangles.append(UInt32(n1))
                        triangles.append(UInt32(n1))
                        triangles.append(UInt32(n2))
                        triangles.append(UInt32(n3))
                    }
                }
                var descr = MeshDescriptor(name: "Cyllinder")
                descr.positions = MeshBuffers.Positions(vertexes)
                descr.normals = MeshBuffers.Normals(normals)
                descr.primitives = .triangles(triangles)
                let model = ModelEntity(
                    mesh: try! .generate(from: [descr]),
                    materials: [SimpleMaterial(color: .red, roughness: 0.4, isMetallic: true)]
                )
                
                model.transform.scale = [0.1, 0.1, 0.1]
                model.transform.translation = [0, -0.5, 0]
                scene.addChild(model)
            }
        }
    }
}

#Preview(windowStyle: .volumetric) {
    ContentView()
}

