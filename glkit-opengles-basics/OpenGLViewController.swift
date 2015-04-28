//
//  OpenGLViewController.swift
//  glkit-opengles-basics
//
//  Created by David Kouřil on 22/04/15.
//  Copyright (c) 2015 dvdkouril. All rights reserved.
//

import GLKit

class OpenGLViewController: GLKViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.compileShaders()
        //self.setupVBOs()
        //self.setupUniforms()
        //self.render()
    }
    
    // function sets up Vertex Buffer Object
//    func setupVBOs() {
//        glGenVertexArraysOES(1, &VAO)
//        glBindVertexArrayOES(VAO)
//        
//        glGenBuffers(1, &vertexBuffer)
//        //glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
//        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
//        println(Vertices.count)
//        glBufferData(GLenum(GL_ARRAY_BUFFER), Vertices.count * sizeof(Vertex), Vertices, GLenum(GL_STATIC_DRAW))
//        
//        //let positionSlotFirstComponent = UnsafePointer<Int>(0)
//        let positionSlotFirstComponent = UnsafePointer<Int>(bitPattern: 0)
//        glEnableVertexAttribArray(positionSlot)
//        glVertexAttribPointer(positionSlot, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(sizeof(Vertex)), positionSlotFirstComponent)
//        
//        glEnableVertexAttribArray(colorSlot)
//        let colorSlotFirstComponent = UnsafePointer<Int>(bitPattern: sizeof(CFloat) * 3)
//        
//        glVertexAttribPointer(colorSlot, 4, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(sizeof(Vertex)), colorSlotFirstComponent)
//        
//        glGenBuffers(1, &indexBuffer)
//        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), indexBuffer)
//        glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), Indices.count * sizeof(GLbyte), Indices, GLenum(GL_STATIC_DRAW))
//        
//        glBindBuffer(GLenum(GL_ARRAY_BUFFER), 0)
//        glBindVertexArrayOES(0)
//        
//    }


}
