//
//  View.swift
//  EyeCube
//
//  Created by Afir Thes on 12.10.2022.
//

import UIKit

extension FloatingPoint {
    var degreesToRadians: Self {
        return self * .pi / 180
    }
}

class Vector2D {
    
    var point: CGPoint {
        CGPoint(x: x, y: y)
    }
    
    init(x: CGFloat, y:CGFloat) {
        self.x = x
        self.y = y
    }
    
    var x: CGFloat = 0
    var y: CGFloat = 0
}

class Vector3D {
    var x: CGFloat = 0
    var y: CGFloat = 0
    var z: CGFloat = 0
    
    init(x: CGFloat, y:CGFloat, z:CGFloat) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    var point: CGPoint {
        CGPoint(x: x, y: y)
    }
    
    func multiplyMatrix(m: Mat4x4)  {
        var ax = x * m.m[0][0] + y * m.m[1][0] + z * m.m[2][0] + m.m[3][0];
        var ay = x * m.m[0][1] + y * m.m[1][1] + z * m.m[2][1] + m.m[3][1];
        var az = x * m.m[0][2] + y * m.m[1][2] + z * m.m[2][2] + m.m[3][2];
        let w:CGFloat = x * m.m[0][3] + y * m.m[1][3] + z * m.m[2][3] + m.m[3][3];

        if (w != 0.0) {
          ax /= w;
          ay /= w;
          az /= w;
        }
        
        x = ax
        y = ay
        z = az
    }
    
    func moveZ(dz: CGFloat) {
        z += dz
    }
    
    func moveY(dy: CGFloat) {
        y += dy
    }
    
    func moveX(dx: CGFloat) {
        x += dx
    }
    
    func scaleZ(sz: CGFloat) {
        z *= sz
    }
    
    func scaleY(sy: CGFloat) {
        y *= sy
    }
    
    func scaleX(sx: CGFloat) {
        x *= sx
    }
}

class Mat4x4 {
    var m:[[CGFloat]] = [[CGFloat]](repeating: [CGFloat](repeating: 0, count: 4), count: 4)
}

class Triangle {
    var p: [Vector3D] = []
    
    init(p: [Vector3D] ) {
        self.p = p
    }
    
    var shape:CAShapeLayer!
    
    func reshape() -> CAShapeLayer {
        if shape == nil {
            shape = CAShapeLayer()
        }
        var path = UIBezierPath()
        path.move(to: p[0].point)
        path.addLine(to: p[1].point)
        path.addLine(to: p[2].point)
        path.addLine(to: p[0].point)
        
        shape.path = path.cgPath
        shape.strokeColor = UIColor.blue.cgColor
        shape.fillColor = .none
        shape.lineWidth = 0.5
        shape.lineCap = .square
        
        return shape
    }
    
    func multiplyMatrix(m: Mat4x4)  {
        for v in p {
            v.multiplyMatrix(m: m)
        }
    }
    
    func moveZ(dz: CGFloat) {
        for v in p {
            v.moveZ(dz: dz)
        }
    }
    
    func moveY(dy: CGFloat) {
        for v in p {
            v.moveY(dy: dy)
        }
    }
    
    func moveX(dx: CGFloat) {
        for v in p {
            v.moveX(dx: dx)
        }
    }
    
    func scaleZ(sz: CGFloat) {
        for v in p {
            v.scaleZ(sz: sz)
        }
    }
    
    func scaleY(sy: CGFloat) {
        for v in p {
            v.scaleY(sy: sy)
        }
    }
    
    func scaleX(sx: CGFloat) {
        for v in p {
            v.scaleX(sx: sx)
        }
    }
    
    func minX() -> CGFloat {
        var minX = CGFloat.infinity
        for v in p {
            if v.x < minX {
                minX = v.x
            }
        }
        return minX
    }
    
    func minY() -> CGFloat {
        var minY = CGFloat.infinity
        for v in p {
            if v.y < minY {
                minY = v.y
            }
        }
        return minY
    }
    
    func minZ() -> CGFloat {
        var minZ = CGFloat.infinity
        for v in p {
            if v.z < minZ {
                minZ = v.z
            }
        }
        return minZ
    }
    
    func maxX() -> CGFloat {
        var maxX = -CGFloat.infinity
        for v in p {
            if v.x > maxX {
                maxX = v.x
            }
        }
        return maxX
    }
    
    func maxY() -> CGFloat {
        var maxY = -CGFloat.infinity
        for v in p {
            if v.y > maxY {
                maxY = v.y
            }
        }
        return maxY
    }
    
    func maxZ() -> CGFloat {
        var maxZ = -CGFloat.infinity
        for v in p {
            if v.z > maxZ {
                maxZ = v.z
            }
        }
        return maxZ
    }
};

class Mesh {
    var tris: [Triangle] = [];
};

class View: UIView {
    
    var answerLayer: CAShapeLayer!
    
    var fTheta:CGFloat =  CGFloat(3.14159) / CGFloat(6)
    
    var points: [Vector2D] = {
        var p:[Vector2D] = []
        p.append(Vector2D(x: 10, y: 10))
        p.append(Vector2D(x: 300, y: 10))
        p.append(Vector2D(x: 300, y: 300))
        return p
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        
        let m = Mat4x4()
        //print(m.m[2][2])
        
        answerLayer = CAShapeLayer()
        
        let shape = UIBezierPath()
        shape.move(to: points[0].point)
        shape.addLine(to: points[1].point)
        shape.addLine(to: points[2].point)
        shape.addLine(to: points[0].point)
        
        answerLayer.path = shape.cgPath
        answerLayer.strokeColor = UIColor.blue.cgColor
        answerLayer.fillColor = .none
        answerLayer.lineWidth = 1.0
        answerLayer.lineCap = .round
        
        //self.layer.addSublayer(answerLayer)
        
        var meshCube = Mesh()
        
        meshCube.tris.append(contentsOf: [
            // SOUTH
            Triangle(p:[
                Vector3D(x: 0, y:0, z:0),
                Vector3D(x: 0, y:1, z:0),
                Vector3D(x: 1, y:1, z:0),
            ]),
            Triangle(p:[
                Vector3D(x: 0, y:0, z:0),
                Vector3D(x: 1, y:1, z:0),
                Vector3D(x: 1, y:0, z:0),
            ]),
            
            /*
             // SOUTH
             { 0.0f, 0.0f, 0.0f,    0.0f, 1.0f, 0.0f,    1.0f, 1.0f, 0.0f },
             { 0.0f, 0.0f, 0.0f,    1.0f, 1.0f, 0.0f,    1.0f, 0.0f, 0.0f },
             */
            
            // EAST
            Triangle(p:[
                Vector3D(x: 1, y:0, z:0),
                Vector3D(x: 1, y:1, z:0),
                Vector3D(x: 1, y:1, z:1),
            ]),
            Triangle(p:[
                Vector3D(x: 1, y:0, z:0),
                Vector3D(x: 1, y:1, z:1),
                Vector3D(x: 1, y:0, z:1),
            ]),
            
            // NORTH
            Triangle(p:[
                Vector3D(x: 1, y:0, z:1),
                Vector3D(x: 1, y:1, z:1),
                Vector3D(x: 0, y:1, z:1),
            ]),
            Triangle(p:[
                Vector3D(x: 1, y:0, z:1),
                Vector3D(x: 0, y:1, z:1),
                Vector3D(x: 0, y:0, z:1),
            ]),
            
            // WEST
            Triangle(p:[
                Vector3D(x: 0, y:0, z:1),
                Vector3D(x: 0, y:1, z:1),
                Vector3D(x: 0, y:1, z:0),
            ]),
            Triangle(p:[
                Vector3D(x: 0, y:0, z:1),
                Vector3D(x: 0, y:1, z:0),
                Vector3D(x: 0, y:0, z:0),
            ]),
            
            // TOP
            Triangle(p:[
                Vector3D(x: 0, y:1, z:0),
                Vector3D(x: 0, y:1, z:1),
                Vector3D(x: 1, y:1, z:1),
            ]),
            Triangle(p:[
                Vector3D(x: 0, y:1, z:0),
                Vector3D(x: 1, y:1, z:1),
                Vector3D(x: 1, y:1, z:0),
            ]),
            
            // BOTTOM
            Triangle(p:[
                Vector3D(x: 1, y:0, z:1),
                Vector3D(x: 0, y:0, z:1),
                Vector3D(x: 0, y:0, z:0),
            ]),
            Triangle(p:[
                Vector3D(x: 1, y:0, z:1),
                Vector3D(x: 0, y:0, z:0),
                Vector3D(x: 1, y:0, z:0),
            ]),
        ])
        
        
        var plane = Mesh()
        
        plane.tris.append(contentsOf: [
            Triangle(p:[
                Vector3D(x: 0, y:0, z:0),
                Vector3D(x: 0, y:1, z:0),
                Vector3D(x: 1, y:1, z:0),
            ])
        ])
        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        /*
         
         // Projection Matrix
         float fNear = 0.1f;
         float fFar = 1000.0f;
         float fFov = 90.0f;
         float fAspectRatio = (float)ScreenHeight() / (float)ScreenWidth();
         float fFovRad = 1.0f / tanf(fFov * 0.5f / 180.0f * 3.14159f);

         matProj.m[0][0] = fAspectRatio * fFovRad;
         matProj.m[1][1] = fFovRad;
         matProj.m[2][2] = fFar / (fFar - fNear);
         matProj.m[3][2] = (-fFar * fNear) / (fFar - fNear);
         matProj.m[2][3] = 1.0f;
         matProj.m[3][3] = 0.0f;
         
         */
        
        let fNear:CGFloat = 0.1
        let fFar:CGFloat = 1000.0
        let fFov:CGFloat = 45.0
        let fAspectRatio:CGFloat = 1.0 //CGFloat(screenWidth) / CGFloat(screenWidth)
        var fFovRad = 1.0 / tan( fFov.degreesToRadians )
        
        var matProj = Mat4x4()
        matProj.m[0][0] = fAspectRatio * fFovRad;
        matProj.m[1][1] = fFovRad;
        matProj.m[2][2] = fFar / (fFar - fNear);
        matProj.m[3][2] = (-fFar * fNear) / (fFar - fNear);
        matProj.m[2][3] = 1.0;
        matProj.m[3][3] = 0.0;
        
        //print("Theta \(fTheta)")
        
        // Rotation Z
        let matRotZ = Mat4x4()
        matRotZ.m[0][0] = cos(fTheta);
        matRotZ.m[0][1] = sin(fTheta);
        matRotZ.m[1][0] = -sin(fTheta);
        matRotZ.m[1][1] = cos(fTheta);
        matRotZ.m[2][2] = 1;
        matRotZ.m[3][3] = 1;

        // Rotation X
        let matRotX = Mat4x4()
        matRotX.m[0][0] = 1;
        matRotX.m[1][1] = cos(fTheta / 2 );
        matRotX.m[1][2] = sin(fTheta / 2);
        matRotX.m[2][1] = -sin(fTheta / 2);
        matRotX.m[2][2] = cos(fTheta / 2);
        matRotX.m[3][3] = 1;
        
        
        var myLayer = CALayer()
        
        var minx:CGFloat = CGFloat.infinity
        var miny:CGFloat = CGFloat.infinity
        var minz:CGFloat = CGFloat.infinity
        
        var maxx:CGFloat = -CGFloat.infinity
        var maxy:CGFloat = -CGFloat.infinity
        var maxz:CGFloat = -CGFloat.infinity
        
        for tri in meshCube.tris {
            
            tri.multiplyMatrix(m: matRotZ)
            tri.multiplyMatrix(m: matRotX)
            tri.moveZ(dz: 3.0)
            tri.multiplyMatrix(m: matProj)
            
            if tri.minX() < minx { minx = tri.minX() }
            if tri.minY() < miny { miny = tri.minY() }
            if tri.minZ() < minz { minz = tri.minZ() }
            
            if tri.maxX() > maxx { maxx = tri.maxX() }
            if tri.maxY() > maxy { maxy = tri.maxY() }
            if tri.maxZ() > maxz { maxz = tri.maxZ() }

            tri.moveX(dx: 1.0)
            tri.moveY(dy: 1.0)
            
            tri.scaleX(sx: 0.5 * screenWidth)
            tri.scaleY(sy: 0.5 * screenWidth)
            
            //print(screenWidth)
            
            
            myLayer.addSublayer(tri.reshape())
            
            
            
        }
        
        self.layer.sublayers?[0].removeFromSuperlayer()
        self.layer.insertSublayer(myLayer, at: 0)
        self.setNeedsDisplay()

        
    }

    
    override func draw(_ rect: CGRect) {
        
    }
       

}
