//
//  StyledLabel.swift
//  Calculator
//
//  Created by Admin on 8/8/16.
//  Copyright © 2016 Yohoho. All rights reserved.
//

import UIKit

@IBDesignable
class StyledLabel: UILabel
{
    @IBInspectable var tracking:CGFloat = 0.8
    // values between about 0.7 to 1.3.  one means normal.
    
    @IBInspectable var stretching:CGFloat = -0.1
    // values between about -.5 to .5.  zero means normal.
    
    override func awakeFromNib()
    {
        tweak()
    }
    
    override func prepareForInterfaceBuilder()
    {
        tweak()
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        let tempLabel = StyledLabel()
        
        tempLabel.frame = self.frame
        tempLabel.text = self.text
        tempLabel.textAlignment = self.textAlignment
        
        tempLabel.font = fontToFitHeight()
        
        //  fontToFitWidth
        if (tempLabel.intrinsicContentSize().width>tempLabel.frame.width){
            repeat {
                tempLabel.decreaseFontSizeBy(0.5)
                print("Font decrased by 0.5 to \(tempLabel.font.pointSize)")
            } while (tempLabel.intrinsicContentSize().width>=tempLabel.frame.width)
        }
        
        self.font = tempLabel.font
    }
    
    private func fontToFitHeight() -> UIFont
    {
        /* Apple have failed to include a basic thing needed in handling text: fitting the text to the height. Here's the simplest and fastest way to do that:
         
         guess = guess * ( desiredHeight / guessHeight )
         
         That's really all there is to it. The rest of the code in this routine is safeguards. Further, the routine iterates a couple of times, which is harmless, to take care of any theoretical bizarre nonlinear sizing issues with strange typefaces. */
        
        guard text?.characters.count > 0 else { return font }
        let desiredHeight:CGFloat = frame.size.height
        guard desiredHeight>1 else { return font }
        var guess:CGFloat
        var guessHeight:CGFloat
        
        print("Searching for... ", desiredHeight)
        
        guess = font.pointSize
        if (guess>1&&guess<1000) { guess = 50 }
        
        guessHeight = sizeIf(guess)
        
        if (guessHeight==desiredHeight)
        {
            print("Fluke, exact match within float math limits, up front")
            return font.fontWithSize(guess)
        }
        
        var iterations:Int = 4
        
        /* It is incredibly unlikely you would need more than four iterations, "two" would rarely be needed. You could imagine some very strange glyph handling where the relationship is non-linear (or something weird): That is the only theoretical reason you'd ever need more than one or two iterations. Note that when you watch the output of the iterations, you'll sometimes/often see same or identical values for the result: this is correct and expected in a float iteration. */
        
        while(iterations>0)
        {
            guess = guess * ( desiredHeight / guessHeight )
            guessHeight = sizeIf(guess)
            
            if (guessHeight==desiredHeight)
            {
                print("Unbelievable fluke, exact match within float math limits while iterating")
                return font.fontWithSize(guess)
            }
            
            iterations -= 1
        }
        
        print("Done!")
        //print("Shame Apple doesn't do this for us!")
        return font.fontWithSize(guess)
    }
    
    private func sizeIf(pointSizeToTry:CGFloat)->(CGFloat)
    {
        let s:CGFloat = text!.sizeWithAttributes(
            [NSFontAttributeName: font.fontWithSize(pointSizeToTry)] )
            .height
        
        print("Guessing .. ", pointSizeToTry, " .. " , s)
        return s
    }
    
    private func tweak()
    {
        let ats = NSMutableAttributedString(string: self.text!)
        let rg = NSRange(location: 0, length: self.text!.characters.count)
        
        ats.addAttribute(
            NSKernAttributeName, value:CGFloat(tracking), range:rg )
        
        ats.addAttribute(
            NSExpansionAttributeName, value:CGFloat(stretching), range:rg )
        
        self.attributedText = ats
    }
    
    func increaseFontSize() {
        self.font =  UIFont(name: self.font!.fontName, size: self.font!.pointSize+1)!
    }
    
    func decreaseFontSize() {
        self.font =  UIFont(name: self.font!.fontName, size: self.font!.pointSize-1)!
    }
    
    func increaseFontSizeBy(size: CGFloat) {
        self.font =  UIFont(name: self.font!.fontName, size: self.font!.pointSize+size)!
    }
    
    func decreaseFontSizeBy(size: CGFloat) {
        self.font =  UIFont(name: self.font!.fontName, size: self.font!.pointSize-size)!
    }
}