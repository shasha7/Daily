//
//  main3.cpp
//  C&C++
//
//  Created by 王伟虎 on 2018/2/7.
//  Copyright © 2018年 wwh. All rights reserved.
//

#include <stdio.h>
#include <iostream>

#include <map>
#include <vector>
#include <deque>
#include <list>
#include <algorithm>
#include <numeric>

using namespace std;

static int const kContestJoinNumber = 24;
static int const kContestJudgeNumber = 10;

class Speaker {
public:
    string name;
    int s_score[3];// 三轮比赛成绩
};

void speech_contest_generate_speaker(map<int, Speaker> &speakerMap, vector<int> &v) {
    string nameSuffix = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    random_shuffle(nameSuffix.begin(), nameSuffix.end());
    
    for (int i = 0; i < kContestJoinNumber; i++) {
        Speaker speaker;
        speaker.name = "Speaker_";
        speaker.name = speaker.name + nameSuffix[i];
        speakerMap.insert(pair<int, Speaker>(100 + i, speaker));
    }
    
    for (int i = 0; i < kContestJoinNumber; i++) {
        v.push_back(100 + i);
    }
}

void speech_contest_sortition(vector<int> &v) {
    random_shuffle(v.begin(), v.end());
}

void speech_contest(int index, vector<int> &v, map<int, Speaker> &speakerMap, vector<int> &winV) {
    multimap<int, int, greater<int>> scoreGroup;
    int tmpCount = 0;
    
    for (vector<int>::iterator it = v.begin(); it != v.end(); it++) {
        tmpCount++;
        {
            deque<int> scoreDeque;
            
            for (int i = 0; i < kContestJudgeNumber; i++) {
                int score = 50 + random()%50;
                scoreDeque.push_back(score);
            }
            sort(scoreDeque.begin(), scoreDeque.end());
            scoreDeque.pop_back();
            scoreDeque.pop_front();
            
            int sum = accumulate(scoreDeque.begin(), scoreDeque.end(), 0);
            int average = sum/scoreDeque.size();
            
            speakerMap[*it].s_score[index] = average;
            
            scoreGroup.insert(pair<int, int>(average, *it));
        }

        //0  1  2  3  4  5
        //6  7  8  9  10 11
        //12 13 14 15 16 17
        //18 19 20 21 22 23
        if (tmpCount % 6 == 0) {
            cout << tmpCount << endl;
            cout << "小组成绩" << endl;
            for (multimap<int, int, greater<int>>::iterator it = scoreGroup.begin(); it != scoreGroup.end(); it++) {
                Speaker speak = speakerMap[it->second];
                cout << "编号：" << it->first << " " << "姓名：" << speak.name << " " << "成绩：" << speak.s_score[index] << " " << endl;
            }
            
            while (scoreGroup.size() > 3) {
                multimap<int, int, greater<int>>::iterator it = scoreGroup.begin();
                winV.push_back(it->second);
                scoreGroup.erase(it);
            }
            scoreGroup.clear();
        }
    }
}

void speech_contest_print(int index, vector<int> &winV, map<int, Speaker> &speakerMap) {
    cout << "晋级名单：" << endl;
    for (vector<int>::iterator it = winV.begin(); it != winV.end(); it++) {
        Speaker speak = speakerMap[(*it)];
        cout << "编号：" << (*it) << " " << "姓名：" << speak.name << " " << "成绩：" << speak.s_score[index] << " " << endl;
    }
}


int main(int argc, const char * argv[]) {
    // insert code here...
    map<int, Speaker> speakerMap;
    
    vector<int> v1;
    vector<int> v2;
    vector<int> v3;
    vector<int> v4;
    
    // 产生选手,获取第一轮参赛名单
    speech_contest_generate_speaker(speakerMap, v1);
    
    // 进行第一轮比赛
    // 选手抽签拿到出场顺序
    int index = 0;
    cout << "任意键开始第一轮";
    cin >> index;
    speech_contest_sortition(v1);
    speech_contest(0, v1, speakerMap, v2);
    speech_contest_print(0, v2, speakerMap);//打印晋级名单
    
    cout << "任意键开始第二轮" << endl;
    cin >> index;
    speech_contest_sortition(v2);
    speech_contest(1, v2, speakerMap, v3);
    speech_contest_print(1, v3, speakerMap);//打印晋级名单
    
    cout << "任意键开始第三轮" << endl;
    cin >> index;
    speech_contest_sortition(v3);
    speech_contest(1, v3, speakerMap, v4);
    speech_contest_print(1, v4, speakerMap);//打印晋级名单
    cout << endl;
    
    cout << "🏆" << "编号：" << v4[0] << " " << "姓名：" << speakerMap[v4[0]].name << " " << "成绩：" << speakerMap[v4[0]].s_score[index] << endl;
    cout << "🥈" << "编号：" << v4[1] << " " << "姓名：" << speakerMap[v4[1]].name << " " << "成绩：" << speakerMap[v4[1]].s_score[index] << endl;
    cout << "🥉" << "编号：" << v4[2] << " " << "姓名：" << speakerMap[v4[2]].name << " " << "成绩：" << speakerMap[v4[2]].s_score[index] << endl;
}
