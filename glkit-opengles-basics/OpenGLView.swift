//
//  OpenGLView.swift
//  glkit-opengles-basics
//
//  Created by David Kouřil on 22/04/15.
//  Copyright (c) 2015 dvdkouril. All rights reserved.
//

import GLKit
import Foundation

struct Vertex {
    var Position: (CFloat, CFloat, CFloat)
    var Color: (CFloat, CFloat, CFloat, CFloat)
}

/*var Vertices = [
    Vertex(Position: (1, -1, 0) , Color: (1, 0, 0, 1)),
    Vertex(Position: (1, 1, 0)  , Color: (0, 1, 0, 1)),
    Vertex(Position: (-1, 1, 0) , Color: (0, 0, 1, 1)),
    Vertex(Position: (-1, -1, 0), Color: (0, 0, 0, 1))
]

var Indices: [GLubyte] = [
    0, 1, 2,
    2, 3, 0
]*/
var Vertices = [
    Vertex(Position: (1, -1, 0), Color: (1, 0, 0, 1)),
    Vertex(Position: (1, 1, 0), Color: (1, 0, 0, 1)),
    Vertex(Position: (-1, 1, 0), Color: (0, 1, 0, 1)),
    Vertex(Position: (-1, -1, 0), Color: (0, 1, 0, 1)),
    Vertex(Position: (1, -1, -1), Color: (1, 0, 0, 1)),
    Vertex(Position: (1, 1, -1), Color: (1, 0, 0, 1)),
    Vertex(Position: (-1, 1, -1), Color: (0, 1, 0, 1)),
    Vertex(Position: (-1, -1, -1), Color: (0, 1, 0, 1))
]

var Indices: [GLubyte] = [
    // Front
    0, 1, 2,
    2, 3, 0,
    // Back
    4, 6, 5,
    4, 7, 6,
    // Left
    2, 7, 3,
    7, 6, 2,
    // Right
    0, 4, 1,
    4, 1, 5,
    // Top
    6, 2, 1,
    1, 6, 5,
    // Bottom
    0, 3, 7,
    0, 7, 4
]


class OpenGLView: GLKView {
    
    
    var VAO: GLuint = GLuint()
    var time: Float = 0.0
    var vertexBuffer: GLuint = GLuint()
    var indexBuffer: GLuint = GLuint()
    var positionSlot: GLuint = GLuint()
    var colorSlot: GLuint = GLuint()
    var program: GLuint = GLuint()
    
//    override init!(frame: CGRect, context: EAGLContext!) {
//        super.init(frame: frame, context: context)
//    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        var api : EAGLRenderingAPI = EAGLRenderingAPI.OpenGLES2
        self.context = EAGLContext(API: api)
        self.drawableDepthFormat = GLKViewDrawableDepthFormat.Format24
        
        if self.context == nil {
            println("Couldn't initialize OpenGL ES context")
            exit(1)
        }
        
        if !EAGLContext.setCurrentContext(self.context) {
            println("Failed to set current OpengGL ES context")
        }
        
        println("view bounds: \(self.bounds.width)x\(self.bounds.height)")
        
        program = self.compileShaders()
        self.setupVBOs()
    }
    

    override func drawRect(rect: CGRect) {
        time += 0.1
        glClearColor(0.1, 0.1, 0.1, 1.0)
        glClearDepthf(1.0)
        glClear(GLenum(GL_COLOR_BUFFER_BIT) | GLenum(GL_DEPTH_BUFFER_BIT))
        
        //println("\(time)")
        updateUniforms()
        
        glBindVertexArrayOES(VAO)
        //glViewport(0, 0, GLint(self.frame.size.width), GLint(self.frame.size.height))
        
        glDrawElements(GLenum(GL_TRIANGLES), GLsizei(Indices.count), GLenum(GL_UNSIGNED_BYTE), nil)
        self.context.presentRenderbuffer(Int(GL_RENDERBUFFER)) // probably doesn't need to be here
        
        glBindVertexArrayOES(0)
    }
    
    func updateUniforms() {
        let timeUniform = glGetUniformLocation(program, "u_time")
        glUniform1f(timeUniform, self.time)
        
        var projectionMatrix = GLKMatrix4MakePerspective(45, Float(self.frame.width / self.frame.height), 1, 1000)
        
        let projectionUniform = glGetUniformLocation(program, "Projection")
        let myMatrix: Array<GLfloat> = [
            projectionMatrix.m00, projectionMatrix.m01, projectionMatrix.m02, projectionMatrix.m03,
            projectionMatrix.m10, projectionMatrix.m11, projectionMatrix.m12, projectionMatrix.m13,
            projectionMatrix.m20, projectionMatrix.m21, projectionMatrix.m22, projectionMatrix.m23,
            projectionMatrix.m30, projectionMatrix.m31, projectionMatrix.m32, projectionMatrix.m33, ]
        
        glUniformMatrix4fv(projectionUniform, GLsizei(1), GLboolean(0), myMatrix)
        
        var modelViewMatrix = GLKMatrix4MakeTranslation(0/*sin(time)*/, 0, -7)
        modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, time, 0, 0, 1)
        modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, time, 1, 0, 0)
        
        let modelViewUniform = glGetUniformLocation(program, "ModelView")
        let myModelViewMatrix: Array<GLfloat> = [
            modelViewMatrix.m00, modelViewMatrix.m01, modelViewMatrix.m02, modelViewMatrix.m03,
            modelViewMatrix.m10, modelViewMatrix.m11, modelViewMatrix.m12, modelViewMatrix.m13,
            modelViewMatrix.m20, modelViewMatrix.m21, modelViewMatrix.m22, modelViewMatrix.m23,
            modelViewMatrix.m30, modelViewMatrix.m31, modelViewMatrix.m32, modelViewMatrix.m33, ]
        
        glUniformMatrix4fv(modelViewUniform, GLsizei(1), GLboolean(0), myModelViewMatrix)
        
    }
    
    func compileShader(shaderName: String?, shaderType: GLenum) -> GLuint {
        
        var shaderPath = NSBundle.mainBundle().pathForResource(shaderName!, ofType: "glsl")
        var error: NSError? = nil
        //var shaderString = String(contentsOfFile: shaderPath!, encoding: NSUTF8StringEncoding, error: &error)
        var shaderString = NSString(contentsOfFile: shaderPath!, encoding: NSUTF8StringEncoding, error: &error)
        var shaderS = shaderString! as String
        shaderS += "\n"
        shaderString = shaderS as NSString
        
        if shaderString == nil {
            println("Failed to set contents shader of shader file!")
        }
        
        var shaderHandle: GLuint = glCreateShader(shaderType)
        
        //var shaderStringUTF8 = shaderString!.utf8
        var shaderStringUTF8 = shaderString!.UTF8String
        //var shaderStringLength: GLint = GLint() // LOL
        var shaderStringLength: GLint = GLint(shaderString!.length)
        glShaderSource(shaderHandle, 1, &shaderStringUTF8, &shaderStringLength)
        
        glCompileShader(shaderHandle)
        
        var compileSuccess: GLint = GLint()
        
        glGetShaderiv(shaderHandle, GLenum(GL_COMPILE_STATUS), &compileSuccess)
        
        if compileSuccess == GL_FALSE {
            println("Failed to compile shader \(shaderName!)!")
            var value: GLint = 0
            glGetShaderiv(shaderHandle, GLenum(GL_INFO_LOG_LENGTH), &value)
            var infoLog: [GLchar] = [GLchar](count: Int(value), repeatedValue: 0)
            var infoLogLength: GLsizei = 0
            glGetShaderInfoLog(shaderHandle, value, &infoLogLength, &infoLog)
            var s = NSString(bytes: infoLog, length: Int(infoLogLength), encoding: NSASCIIStringEncoding)
            println(s)
            
            exit(1)
        }
        
        
        return shaderHandle
        
    }
    
    // function compiles vertex and fragment shaders into program. Returns program handle
    func compileShaders() -> GLuint {
        
        var vertexShader: GLuint = self.compileShader("SimpleVertex", shaderType: GLenum(GL_VERTEX_SHADER))
        var fragmentShader: GLuint = self.compileShader("SimpleFragment", shaderType: GLenum(GL_FRAGMENT_SHADER))
        
        var programHandle: GLuint = glCreateProgram()
        glAttachShader(programHandle, vertexShader)
        glAttachShader(programHandle, fragmentShader)
        glLinkProgram(programHandle)
        
        var linkSuccess: GLint = GLint()
        glGetProgramiv(programHandle, GLenum(GL_LINK_STATUS), &linkSuccess)
        if linkSuccess == GL_FALSE {
            println("Failed to create shader program!")
            
            var value: GLint = 0
            glGetProgramiv(programHandle, GLenum(GL_INFO_LOG_LENGTH), &value)
            var infoLog: [GLchar] = [GLchar](count: Int(value), repeatedValue: 0)
            var infoLogLength: GLsizei = 0
            glGetProgramInfoLog(programHandle, value, &infoLogLength, &infoLog)
            var s = NSString(bytes: infoLog, length: Int(infoLogLength), encoding: NSASCIIStringEncoding)
            println(s)
            
            //GLchar messages[1024]
            //glGetProgramInfoLog(programHandle, sizeof(messages), 0, &messages[0]);
            exit(1)
        }
        
        glUseProgram(programHandle)
        
        self.positionSlot = GLuint(glGetAttribLocation(programHandle, "Position"))
        self.colorSlot = GLuint(glGetAttribLocation(programHandle, "SourceColor"))
        glEnableVertexAttribArray(self.positionSlot)
        glEnableVertexAttribArray(self.colorSlot)
        
        
        return programHandle
    }

    
    func setupVBOs() {
        glGenVertexArraysOES(1, &VAO)
        glBindVertexArrayOES(VAO)
        
        glGenBuffers(1, &vertexBuffer)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
        println("Vertices.count: \(Vertices.count)")
        glBufferData(GLenum(GL_ARRAY_BUFFER), Vertices.count * sizeof(Vertex), Vertices, GLenum(GL_STATIC_DRAW))
        
        //let positionSlotFirstComponent = UnsafePointer<Int>(0)
        let positionSlotFirstComponent = UnsafePointer<Int>(bitPattern: 0)
        glEnableVertexAttribArray(positionSlot)
        glVertexAttribPointer(positionSlot, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(sizeof(Vertex)), positionSlotFirstComponent)
        
        glEnableVertexAttribArray(colorSlot)
        let colorSlotFirstComponent = UnsafePointer<Int>(bitPattern: sizeof(CFloat) * 3)
        
        glVertexAttribPointer(colorSlot, 4, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(sizeof(Vertex)), colorSlotFirstComponent)
        
        glGenBuffers(1, &indexBuffer)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), indexBuffer)
        glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), Indices.count * sizeof(GLbyte), Indices, GLenum(GL_STATIC_DRAW))
        
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), 0)
        glBindVertexArrayOES(0)
        
    }

    
}
