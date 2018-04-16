//
//  MIT License
//
//  Copyright (c) 2014 Bob McCune http://bobmccune.com/
//  Copyright (c) 2014 TapHarmonic, LLC http://tapharmonic.com/
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "THSpeechController.h"
#import <AVFoundation/AVFoundation.h>

@interface THSpeechController ()
@property (strong, nonatomic) AVSpeechSynthesizer *synthesizer;
@property (strong, nonatomic) NSArray *voices;
@property (strong, nonatomic) NSArray *speechStrings;
@end

@implementation THSpeechController

+ (instancetype)speechController {
    return [[self alloc] init];
}

- (id)init {
    self = [super init];
    if (self) {
        _synthesizer = [[AVSpeechSynthesizer alloc] init];
        NSLog(@"[AVSpeechSynthesisVoice speechVoices] = %@", [AVSpeechSynthesisVoice speechVoices]);

        /*
         (
         "[AVSpeechSynthesisVoice 0x608000001160] Language: ar-SA, Name: Maged, Quality: Default [com.apple.ttsbundle.Maged-compact]",
         "[AVSpeechSynthesisVoice 0x608000001660] Language: cs-CZ, Name: Zuzana, Quality: Default [com.apple.ttsbundle.Zuzana-compact]",
         "[AVSpeechSynthesisVoice 0x6080000013e0] Language: da-DK, Name: Sara, Quality: Default [com.apple.ttsbundle.Sara-compact]",
         "[AVSpeechSynthesisVoice 0x608000000e20] Language: de-DE, Name: Anna, Quality: Default [com.apple.ttsbundle.Anna-compact]",
         "[AVSpeechSynthesisVoice 0x608000001220] Language: el-GR, Name: Melina, Quality: Default [com.apple.ttsbundle.Melina-compact]",
         "[AVSpeechSynthesisVoice 0x608000001020] Language: en-AU, Name: Karen, Quality: Default [com.apple.ttsbundle.Karen-compact]",
         "[AVSpeechSynthesisVoice 0x608000000ee0] Language: en-GB, Name: Daniel, Quality: Default [com.apple.ttsbundle.Daniel-compact]",
         "[AVSpeechSynthesisVoice 0x6080000012a0] Language: en-IE, Name: Moira, Quality: Default [com.apple.ttsbundle.Moira-compact]",
         "[AVSpeechSynthesisVoice 0x6080000013a0] Language: en-US, Name: Samantha, Quality: Default [com.apple.ttsbundle.Samantha-compact]",
         "[AVSpeechSynthesisVoice 0x6080000014a0] Language: en-ZA, Name: Tessa, Quality: Default [com.apple.ttsbundle.Tessa-compact]",
         "[AVSpeechSynthesisVoice 0x6080000012e0] Language: es-ES, Name: Monica, Quality: Default [com.apple.ttsbundle.Monica-compact]",
         "[AVSpeechSynthesisVoice 0x608000001360] Language: es-MX, Name: Paulina, Quality: Default [com.apple.ttsbundle.Paulina-compact]",
         "[AVSpeechSynthesisVoice 0x608000001420] Language: fi-FI, Name: Satu, Quality: Default [com.apple.ttsbundle.Satu-compact]",
         "[AVSpeechSynthesisVoice 0x608000000de0] Language: fr-CA, Name: Amelie, Quality: Default [com.apple.ttsbundle.Amelie-compact]",
         "[AVSpeechSynthesisVoice 0x6080000014e0] Language: fr-FR, Name: Thomas, Quality: Default [com.apple.ttsbundle.Thomas-compact]",
         "[AVSpeechSynthesisVoice 0x608000000e60] Language: he-IL, Name: Carmit, Quality: Default [com.apple.ttsbundle.Carmit-compact]",
         "[AVSpeechSynthesisVoice 0x6080000010e0] Language: hi-IN, Name: Lekha, Quality: Default [com.apple.ttsbundle.Lekha-compact]",
         "[AVSpeechSynthesisVoice 0x6080000011a0] Language: hu-HU, Name: Mariska, Quality: Default [com.apple.ttsbundle.Mariska-compact]",
         "[AVSpeechSynthesisVoice 0x608000000ea0] Language: id-ID, Name: Damayanti, Quality: Default [com.apple.ttsbundle.Damayanti-compact]",
         "[AVSpeechSynthesisVoice 0x608000000d60] Language: it-IT, Name: Alice, Quality: Default [com.apple.ttsbundle.Alice-compact]",
         "[AVSpeechSynthesisVoice 0x608000001060] Language: ja-JP, Name: Kyoko, Quality: Default [com.apple.ttsbundle.Kyoko-compact]",
         "[AVSpeechSynthesisVoice 0x6080000015e0] Language: ko-KR, Name: Yuna, Quality: Default [com.apple.ttsbundle.Yuna-compact]",
         "[AVSpeechSynthesisVoice 0x608000000f20] Language: nl-BE, Name: Ellen, Quality: Default [com.apple.ttsbundle.Ellen-compact]",
         "[AVSpeechSynthesisVoice 0x608000001560] Language: nl-NL, Name: Xander, Quality: Default [com.apple.ttsbundle.Xander-compact]",
         "[AVSpeechSynthesisVoice 0x608000001320] Language: no-NO, Name: Nora, Quality: Default [com.apple.ttsbundle.Nora-compact]",
         "[AVSpeechSynthesisVoice 0x608000001620] Language: pl-PL, Name: Zosia, Quality: Default [com.apple.ttsbundle.Zosia-compact]",
         "[AVSpeechSynthesisVoice 0x608000001120] Language: pt-BR, Name: Luciana, Quality: Default [com.apple.ttsbundle.Luciana-compact]",
         "[AVSpeechSynthesisVoice 0x608000000fa0] Language: pt-PT, Name: Joana, Quality: Default [com.apple.ttsbundle.Joana-compact]",
         "[AVSpeechSynthesisVoice 0x608000000f60] Language: ro-RO, Name: Ioana, Quality: Default [com.apple.ttsbundle.Ioana-compact]",
         "[AVSpeechSynthesisVoice 0x608000001260] Language: ru-RU, Name: Milena, Quality: Default [com.apple.ttsbundle.Milena-compact]",
         "[AVSpeechSynthesisVoice 0x6080000010a0] Language: sk-SK, Name: Laura, Quality: Default [com.apple.ttsbundle.Laura-compact]",
         "[AVSpeechSynthesisVoice 0x608000000da0] Language: sv-SE, Name: Alva, Quality: Default [com.apple.ttsbundle.Alva-compact]",
         "[AVSpeechSynthesisVoice 0x608000000fe0] Language: th-TH, Name: Kanya, Quality: Default [com.apple.ttsbundle.Kanya-compact]",
         "[AVSpeechSynthesisVoice 0x6080000015a0] Language: tr-TR, Name: Yelda, Quality: Default [com.apple.ttsbundle.Yelda-compact]",
         "[AVSpeechSynthesisVoice 0x608000001520] Language: zh-CN, Name: Ting-Ting, Quality: Default [com.apple.ttsbundle.Ting-Ting-compact]",
         "[AVSpeechSynthesisVoice 0x608000001460] Language: zh-HK, Name: Sin-Ji, Quality: Default [com.apple.ttsbundle.Sin-Ji-compact]",
         "[AVSpeechSynthesisVoice 0x6080000011e0] Language: zh-TW, Name: Mei-Jia, Quality: Default [com.apple.ttsbundle.Mei-Jia-compact]"
         )
         */
        _voices = @[[AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"],
                    [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-TW"]];

        _speechStrings = [self buildSpeechStrings];
    }
    return self;
}

- (NSArray *)buildSpeechStrings {
    return @[@"非常棒",
             @"你好",
             @"啊啊啊啊啊?",
             @"哦哦哦哦哦哦哦哦哦.",
             @"然后说, 你知道UIButton setTitle的时候才会创建UILabel",
             @"Oh, they're all my babies.  I couldn't possibly choose.",
             @"It was great to speak with you!",
             @"The pleasure was all mine!  Have fun!"];
}

- (void)beginConversation {
    for (NSUInteger i = 0; i < self.speechStrings.count; i++) {
        AVSpeechUtterance *utterance =
            [[AVSpeechUtterance alloc] initWithString:self.speechStrings[i]];
        utterance.voice = self.voices[i % 2];
        utterance.rate = 0.5f;
        utterance.pitchMultiplier = 0.8f;
        utterance.postUtteranceDelay = 0.1f;
        utterance.preUtteranceDelay = 0.3f;
        [self.synthesizer speakUtterance:utterance];
    }
}

@end
