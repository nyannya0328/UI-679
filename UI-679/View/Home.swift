//
//  Home.swift
//  UI-679
//
//  Created by nyannyan0328 on 2022/09/24.
//

import SwiftUI

struct Home: View {
    @State var dragOffset : CGSize = .zero
    @State var StartAnimation : Bool = false
    
    @State var currentPicker : String = "first"
    var body: some View {
        VStack{
            
           Text("Meta Ball Animation")
                .font(.title2.bold())
                .foregroundColor(.white)
            
            
            Picker(selection: $currentPicker) {
                
                Text("Metal")
                    .tag("first")
                
                Text("Clubbed")
                    .tag("second")
                
            } label: {
                
            }
            .padding(.horizontal)
            .pickerStyle(.segmented)
           
            
            if currentPicker == "first"{
               SingleMetaBallView()
                
            }
            else{
                
                
                ClabbedView()
            }
            
            
        }
     //   .ignoresSafeArea()
    }
    @ViewBuilder
    func ClabbedView()->some View{
        
        Rectangle()
            .fill(.linearGradient(colors: [Color("c1"),Color("c2")], startPoint: .top, endPoint: .bottom))
            .mask {
                
                TimelineView(.animation(minimumInterval:3.5,paused: false)){_ in
                    
                    
                    Canvas { context, size in
                        context.addFilter(.alphaThreshold(min: 0.3,color: .white))
                        context.addFilter(.blur(radius: 20))
                        
                        context.drawLayer { cxt in
                            
                            for index in 1...30{
                                
                                if let contentImage = context.resolveSymbol(id: index){
                                    
                                    cxt.draw(contentImage, at: CGPoint(x: size.width / 2, y: size.height / 2))
                                    
                                }
                            }
                        }
                        
                    } symbols: {
                        
                        ForEach(1...20 ,id:\.self){index in
                            
                            let offset = (StartAnimation ? CGSize(width: .random(in: -240...240), height: .random(in: -200...200)) : .zero)
                            
                            ClubbedRoundRectangle(offset: offset)
                        }
                        
                    }

                    
                    
                    
                    
                }
             
                
            }
            .contentShape(Rectangle())
            .onTapGesture {
                
                
                withAnimation{
                    
                    StartAnimation.toggle()
                }
            
            }
        
       
      
            
        
    }
    @ViewBuilder
    func ClubbedRoundRectangle(offset : CGSize)->some View{
        
        RoundedRectangle(cornerRadius: 10, style: .continuous)
            .fill(.white)
         .frame(width: 120,height: 120)
         .offset(offset)
         .animation(.easeIn(duration: 5), value: offset)
        
    }
    @ViewBuilder
    func SingleMetaBallView ()->some View{
        
        Rectangle()
            .fill(.linearGradient(colors: [Color("c1"),Color("c2")], startPoint: .top, endPoint: .bottom))
            .mask {
                
                Canvas { context, size in
                    context.addFilter(.alphaThreshold(min: 0.3,color: .white))
                    context.addFilter(.blur(radius: 20))
                    
                    context.drawLayer { cxt in
                        
                        for index in [1,2]{
                            
                            if let resolvedImage = context.resolveSymbol(id: index){
                             
                                cxt.draw(resolvedImage, at: CGPoint(x: size.width / 2, y: size.height / 2))
                            }
                        }
                    }
                    
                    
                } symbols: {
                    
                    BallView()
                        .tag(1)
                    
                    BallView(offset: dragOffset)
                        .tag(2)
                    
                }

                
            }
            .gesture(
            
            DragGesture()
                .onChanged({ value in
                    dragOffset = value.translation
                })
                .onEnded({ value in
                    
                    withAnimation(.interactiveSpring(response: 0.5,dampingFraction: 0.8,blendDuration: 0.7)){
                        dragOffset = .zero
                        
                    }
                })
            
            )
        
        
    }
    @ViewBuilder
    func BallView(offset : CGSize = .zero)->some View{
        
        Circle()
            .fill(.white)
            .frame(width: 150,height: 150)
            .offset(offset)
        
        
    }
  
}
struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
