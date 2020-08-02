# -*- coding: utf-8 -*-
"""
Created on Tue Jul 21 22:18:53 2020

@author: anushka """

import numpy as np
from flask import Flask, request, make_response
import json
from flask_cors import cross_origin
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.naive_bayes import MultinomialNB

app = Flask(__name__)

model_symptoms=['itching','skin_rash','nodal_skin_eruptions','continuous_sneezing','shivering','chills','joint_pain','stomach_pain','acidity','ulcers_on_tongue','muscle_wasting','vomiting','burning_micturition','spotting_ urination','fatigue','weight_gain','anxiety','cold_hands_and_feets','mood_swings','weight_loss','restlessness','lethargy','patches_in_throat','irregular_sugar_level','cough','high_fever','sunken_eyes','breathlessness','sweating','dehydration','indigestion','headache','yellowish_skin','dark_urine','nausea','loss_of_appetite','pain_behind_the_eyes','back_pain','constipation','abdominal_pain','diarrhoea','mild_fever','yellow_urine','yellowing_of_eyes','acute_liver_failure','fluid_overload','swelling_of_stomach','swelled_lymph_nodes','malaise','blurred_and_distorted_vision','phlegm','throat_irritation','redness_of_eyes','sinus_pressure','runny_nose','congestion','chest_pain','weakness_in_limbs','fast_heart_rate','pain_during_bowel_movements','pain_in_anal_region','bloody_stool','irritation_in_anus','neck_pain','dizziness','cramps','bruising','obesity','swollen_legs','swollen_blood_vessels','puffy_face_and_eyes','enlarged_thyroid','brittle_nails','swollen_extremeties','excessive_hunger','extra_marital_contacts','drying_and_tingling_lips','slurred_speech','knee_pain','hip_joint_pain','muscle_weakness','stiff_neck','swelling_joints','movement_stiffness','spinning_movements','loss_of_balance','unsteadiness','weakness_of_one_body_side','loss_of_smell','bladder_discomfort','foul_smell_of urine','continuous_feel_of_urine','passage_of_gases','internal_itching','toxic_look_(typhos)','depression','irritability','muscle_pain','altered_sensorium','red_spots_over_body','belly_pain','abnormal_menstruation','dischromic _patches','watering_from_eyes','increased_appetite','polyuria','family_history','mucoid_sputum','rusty_sputum','lack_of_concentration','visual_disturbances','receiving_blood_transfusion','receiving_unsterile_injections','coma','stomach_bleeding','distention_of_abdomen','history_of_alcohol_consumption','fluid_overload.1','blood_in_sputum','prominent_veins_on_calf','palpitations','painful_walking','pus_filled_pimples','blackheads','scurring','skin_peeling','silver_like_dusting','small_dents_in_nails','inflammatory_nails','blister','red_sore_around_nose','yellow_crust_ooze','Heberdens node','Murphys sign','Stahlis line','abdomen acute','abdominal bloating','abdominal tenderness','abnormal sensation','abnormally hard consistency','abortion','abscess bacterial','absences finding','achalasia','ache','adverse effect','adverse reaction','agitation','air fluid level','alcohol binge episode','alcoholic withdrawal symptoms','ambidexterity','angina pectoris','anorexia','anosmia','aphagia','apyrexial','arthralgia','ascites','asterixis','asthenia','asymptomatic','ataxia','atypia','aura','awakening early','barking cough','bedridden','behavior hyperactive','behavior showing increased motor activity','blackout','blanch','bleeding of vagina','bowel sounds decreased','bradycardia','bradykinesia','breakthrough pain','breath sounds decreased','breath-holding spell','breech presentation','bruit','burning sensation','cachexia','cardiomegaly','cardiovascular event','cardiovascular finding','catatonia','catching breath','charleyhorse','chest discomfort','chest tightness','chill','choke','cicatrisation','clammy skin','claudication','clonus','clumsiness','colic abdominal','consciousness clear','coordination abnormal','cushingoid facies','cushingoid habitus','cyanosis','cystic lesion','debilitation','decompensation','decreased body weight','decreased stool caliber','decreased translucency','diarrhea','difficulty','difficulty passing urine','disequilibrium','distended abdomen','distress respiratory','disturbed family','dizzy spells','drool','drowsiness','dullness','dysarthria','dysdiadochokinesia','dysesthesia','dyspareunia','dyspnea','dyspnea on exertion','dysuria','ecchymosis','egophony','elation','emphysematous change','energy increased','enuresis','erythema','estrogen use','excruciating pain','exhaustion','extrapyramidal sign','extreme exhaustion','facial paresis','fall','fatigability','fear of falling','fecaluria','feces in rectum','feeling hopeless','feeling strange','feeling suicidal','feels hot/feverish','fever','flare','flatulence','floppy','flushing','focal seizures','food intolerance','formication','frail','fremitus','frothy sputum','gag','gasping for breath','general discomfort','general unsteadiness','giddy mood','gravida 0','gravida 10','green sputum','groggy','guaiac positive','gurgle','hacking cough','haemoptysis','haemorrhage','hallucinations auditory','hallucinations visual','has religious belief','heartburn','heavy feeling','heavy legs','hematochezia','hematocrit decreased','hematuria','heme positive','hemianopsia homonymous','hemiplegia','hemodynamically stable','hepatomegaly','hepatosplenomegaly','hirsutism','history of - blackout','hoard','hoarseness','homelessness','homicidal thoughts','hot flush','hunger','hydropneumothorax','hyperacusis','hypercapnia','hyperemesis','hyperhidrosis disorder','hyperkalemia','hypersomnia','hypersomnolence','hypertonicity','hyperventilation','hypesthesia','hypoalbuminemia','hypocalcemia result','hypokalemia','hypokinesia','hypometabolism','hyponatremia','hypoproteinemia','hypotension','hypothermia, natural','hypotonic','hypoxemia','immobile','impaired cognition','inappropriate affect','incoherent','indifferent mood','intermenstrual heavy bleeding','intoxication','irritable mood','jugular venous distention','labored breathing','lameness','large-for-dates fetus','left atrial hypertrophy','lesion','lightheadedness','lip smacking','loose associations','low back pain','lung nodule','macerated skin','macule','mass in breast','mass of body structure','mediastinal shift','mental status changes','metastatic lesion','milky','moan','monoclonal','monocytosis','mood depressed','moody','motor retardation','muscle hypotonia','muscle twitch','myalgia','mydriasis','myoclonus','nasal discharge present','nasal flaring','nausea and vomiting','neck stiffness','neologism','nervousness','night sweat','nightmare','no known drug allergies','no status change','noisy respiration','non-productive cough','nonsmoker','numbness','numbness of hand','oliguria','orthopnea','orthostasis','out of breath','overweight','pain','pain abdominal','pain back','pain chest','pain foot','pain in lower limb','pain neck','painful swallowing','pallor','palpitation','panic','pansystolic murmur','para 1','para 2','paralyse','paraparesis','paresis','paresthesia','passed stones','patient non compliance','pericardial friction rub','phonophobia','photophobia','photopsia','pin-point pupils','pleuritic pain','pneumatouria','polydypsia','polymyalgia','poor dentition','poor feeding','posterior rhinorrhea','posturing','presence of q wave','pressure chest','previous pregnancies 2','primigravida','prodrome','productive cough','projectile vomiting','prostate tender','prostatism','proteinemia','pruritus','pulse absent','pulsus paradoxus','pustule','qt interval prolonged','r wave feature','rale','rambling speech','rapid shallow breathing','red blotches','redness','regurgitates after swallowing','renal angle tenderness','rest pain','retch','retropulsion','rhd positive','rhonchus','rigor - temperature-associated observation','rolling of eyes','room spinning','satiety early','scar tissue','sciatica','scleral icterus','scratch marks','sedentary','seizure','sensory discomfort','shooting pain','shortness of breath','side pain','sinus rhythm','sleeplessness','sleepy','slowing of urinary stream','sneeze','sniffle','snore','snuffle','soft tissue swelling','sore to touch','spasm','speech slurred','splenomegaly','spontaneous rupture of membranes','sputum purulent','st segment depression','st segment elevation','stiffness','stinging sensation','stool color yellow','stridor','stuffy nose','stupor','suicidal','superimposition','sweat','sweating increased','swelling','symptom aggravating factors','syncope','systolic ejection murmur','systolic murmur','t wave inverted','tachypnea','tenesmus','terrify','thicken','throat sore','throbbing sensation quality','tinnitus','tired','titubation','todd paralysis','tonic seizures','transaminitis','transsexual','tremor','tremor resting','tumor cell invasion','unable to concentrate','unconscious state','uncoordination','underweight','unhappy','unresponsiveness','unsteady gait','unwell','urge incontinence','urgency of micturition','urinary hesitation','urinoma','verbal auditory hallucinations','verbally abusive behavior','vertigo','vision blurred','weepiness','weight gain','welt','wheelchair bound','wheezing','withdraw','worry','yellow sputum']
@app.route('/webhook', methods=['POST'])
@cross_origin()
def webhook(): 
    req = request.get_json(silent=True, force=True)
    res = processRequest(req)
    res = json.dumps(res, indent=4)
    r = make_response(res)
    r.headers['Content-Type'] = 'application/json'
    return r

def processRequest(req):
    user_symptoms = Symptom(req)
    Top3diseasepred = predictDisease(user_symptoms)
    res = makeWebhookResult(Top3diseasepred)
    return res

def Symptom(req):
    user_symptoms=req.get("result").get("symptoms")
    user_symptoms=list(user_symptoms)
    return user_symptoms

def predictDisease(user_symptoms):
    symptom=np.zeros([526],dtype=float)
    finaldataset=pd.read_csv('finaldataset.csv')
    labels=finaldataset['prognosis']
    fdc=finaldataset
    fdc.drop('prognosis',axis=1,inplace=True)
    x_train,x_test,y_train,y_test=train_test_split(fdc,labels,test_size=0.25,random_state=20)
    model=MultinomialNB()
    model.fit(x_train,y_train)
    Alldiseases=model.classes_.tolist()
    
    indexes=[]
    for i in range(len(model_symptoms)):
        if model_symptoms[i] in user_symptoms:
            indexes.append(i)
    for i in indexes:
        symptom[i]=1
    top3=[]
    probab=model.predict_proba([symptom]).tolist()  
    for j in range(3):
        max=-10000000000
        h=0
        for i in range(len(probab[0])):
            if probab[0][i]>max:
                max=probab[0][i]
                h=i 
    k=[]
    k.append(Alldiseases[h])
    k.append(probab[0][h])
    top3.append(k)
    probab[0][h]=-1 
    return top3

def makeWebhookResult(Top3diseasepred):
    result=""
    for i in Top3diseasepred:
        result+="Probability of "+str(i[0])+"is "+"{:2.3f}".format((i[1]*100))+'%'+'\n'
    return result 

if __name__ == '__main__':
    app.run(debug=False)


