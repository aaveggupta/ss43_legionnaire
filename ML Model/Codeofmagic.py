# -*- coding: utf-8 -*-
"""
Created on Thu Jul 23 14:59:36 2020

@author: anushka dwivedi
"""
import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.naive_bayes import MultinomialNB
from sklearn.ensemble import RandomForestClassifier
from sklearn.neural_network import MLPClassifier
from sklearn.linear_model import SGDClassifier
from flask import Flask, request, make_response
import json
from flask_cors import cross_origin
import pickle
from collections import OrderedDict

User_Symptoms={}
model_symptoms=['itching','skin rash','nodal skin eruptions','continuous sneezing','shivering','chills','joint pain','stomach pain','acidity','ulcers on tongue','muscle wasting','vomiting','burning micturition','spotting  urination','fatigue','weight gain','anxiety','cold hands and feets','mood swings','weight loss','restlessness','lethargy','patches in throat','irregular sugar level','cough','high fever','sunken eyes','breathlessness','sweating','dehydration','indigestion','headache','yellowish skin','dark urine','nausea','loss of appetite','pain behind the eyes','back pain','constipation','abdominal pain','diarrhoea','mild fever','yellow urine','yellowing of eyes','acute liver failure','fluid overload','swelling of stomach','swelled lymph nodes','malaise','blurred and distorted vision','phlegm','throat irritation','redness of eyes','sinus pressure','runny nose','congestion','chest pain','weakness in limbs','fast heart rate','pain during bowel movements','pain in anal region','bloody stool','irritation in anus','neck pain','dizziness','cramps','bruising','obesity','swollen legs','swollen blood vessels','puffy face and eyes','enlarged thyroid','brittle nails','swollen extremeties','excessive hunger','extra marital contacts','drying and tingling lips','slurred speech','knee pain','hip joint pain','muscle weakness','stiff neck','swelling joints','movement stiffness','spinning movements','loss of balance','unsteadiness','weakness of one body side','loss of smell','bladder discomfort','foul smell of urine','continuous feel of urine','passage of gases','internal itching','toxic look (typhos)','depression','irritability','muscle pain','altered sensorium','red spots over body','belly pain','abnormal menstruation','dischromic  patches','watering from eyes','increased appetite','polyuria','family history','mucoid sputum','rusty sputum','lack of concentration','visual disturbances','receiving blood transfusion','receiving unsterile injections','coma','stomach bleeding','distention of abdomen','history of alcohol consumption','fluid overload.1','blood in sputum','prominent veins on calf','palpitations','painful walking','pus filled pimples','blackheads','scurring','skin peeling','silver like dusting','small dents in nails','inflammatory nails','blister','red sore around nose','yellow crust ooze']
information_ofD=['(vertigo) Paroxysmsal  Positional Vertigo', 'nil', 'otolaryngologist(ENT specialist)','AIDS', 'HIV', 'Infectious Disease specialist','Acne', 'nil', 'Dermatologist','Alcoholic hepatitis', 'nil', 'Gastroenterologist or commonly liver specialist','Allergy', 'nil', 'allergist','Arthritis', 'nil', 'Rheumatologists','Bronchial Asthma', 'Asthma', 'allergist','Cervical spondylosis', 'Arthritis of neck', 'Neurosurgeon and orthopedic surgeon','Chicken pox', 'nil', 'Dermatologist','Chronic cholestasis', 'Cholestasis', 'liver specialist','Common Cold', 'nil', 'nil','Dengue', 'nil', 'Infectious disease specialist','Diabetes ', 'nil', 'endocrinologist','Dimorphic hemmorhoids(piles)', 'piles', 'gastroenterologist','Drug Reaction', 'nil', 'allergist','Fungal infection', 'nil', 'Infectious disease specialist','GERD', 'Acid reflux', 'specialist in medicine','Gastroenteritis', 'gastro', 'gastroenterologist','Heart attack', 'nil', 'Cardiologist','hepatitis A', 'hepatovirus', 'gastroenterologist','Hepatitis B', 'nil', 'gastroenterologist','Hepatitis C', 'nil', 'gastroenterologist','Hepatitis D', 'nil', 'gastroenterologist','Hepatitis E', 'nil', 'gastroenterologist','Hypertension', 'high blood pressure', 'Cardiologist','Hyperthyroidism', 'overactive thyroid', 'endocrinologist','Hypoglycemia', 'low blood sugar', 'endocrinologist','Hypothyroidism', 'nil', 'endocrinologist','Impetigo', 'Skin infection', 'dermatologist','Jaundice', 'yellow fever', 'gastroenterologist','Malaria', 'nil', 'Infectious disease specialist','Migraine', 'nil', 'neurologist','Osteoarthristis', 'degenerative joint disease', 'Rheumatologist','Paralysis (brain hemorrhage)', 'nil', 'neurosurgeon','Peptic ulcer diseae', 'gastric ulcer', 'gastroenterologist','Pneumonia', 'nil', 'pulmonologist','Psoriasis', 'nil', 'dermatologist','Tuberculosis', 'TB', 'Infectious disease specialist','Typhoid', 'nil', 'Infectious disease specialist','Urinary tract infection', 'nil', 'Urologist','Varicose veins', 'spider veins', 'vascular surgeon']
Serious_Diseases=['AIDS','Chicken pox','Dengue','Diabetes ','Dimorphic hemmorhoids(piles)','Heart attack','Hepatitis C','Hepatitis D','Hypertension ','Hyperthyroidism','Jaundice','Malaria','Osteoarthristis','Paralysis (brain hemorrhage)','Pneumonia','Tuberculosis','Typhoid','Urinary tract infection']
emergency=['heart attack','1.Give CPR: Push hard and fast Push down at least two inches at a rate of 100 to 120 pushes a minute in the center of the chest, allowing the chest to come back up to its normal position after each push.\n2.Use an AED Use the automated external defibrillator as soon as it arrives. Turn it on and follow the prompts.\n3.Do this until the advance training takes over.','panic attack','1.Use deep breathing.\n2.Close your eyes.\n3.Use muscle relaxation techniques.','brain attack','1.Try to smile for checking one side of the face droop.\n 2.Try to raise both arms and check does one arm drift downward.\n3.Try to repeat a simple sentence and check are the words slurred.\n4.Go to hospital immediately.']
app = Flask(__name__)

@app.route('/')
def hello():
    return 'Hello World'

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
    result = req.get("queryResult")
    parameters = result.get("parameters")
    sessionid=req.get("sessionId")
    global User_Symptoms
    if req.get("queryResult").get("action") == "add_symptom":
        result = req.get("queryResult")
        parameters = result.get("parameters")
        ans=[]
        ans=ans+parameters.get("Disease")
        if sessionid in User_Symptoms.keys():
            User_Symptoms[sessionid]=User_Symptoms[sessionid]+ans
        else:
            User_Symptoms[sessionid]=ans
        
    elif req.get("queryResult").get("action") == "bmi.calculate":
        height=parameters.get("unit-length").get("amount")
        weight=parameters.get("unit-weight").get("amount")
        if parameters.get("unit-length").get("unit")=='cm':
            height=height/100
            
        answer=round(weight/(height*height),2)
        fulfillmentText = "Your BMI is "+str(answer)+"kg per metre square"
        return {
            "fulfillmentText": fulfillmentText
        }
    
    elif req.get("queryResult").get("action") == "help.disease":
        dis=req.get("queryResult").get("parameters").get("helponthego")
        an="Your emergency info is -"
        if str(dis) in emergency:
            index=emergency.index(str(dis))
            an+=emergency[index+1]
        fulfillmentText = an
        return {
            "fulfillmentText": fulfillmentText
        }
    
    
    elif req.get("queryResult").get("action") == "add_symptom.no":
        user_symptoms = User_Symptoms[sessionid]
        """
        symptom=np.zeros([132],dtype=float)
        model=pickle.load(open('mnb.pkl','rb'))
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
                probab[0][h]=-1 """
        symp=""
        symp+="You have shown the symptoms of "
        if len(user_symptoms)==1:
            symp+=str(user_symptoms[len(user_symptoms)-1])+".\n"+"\n"
        else:   
            for i in range(len(user_symptoms)-1):
                symp+=str(user_symptoms[i])+" "
            symp+="and "+str(user_symptoms[len(user_symptoms)-1])+".\n"+"\n"
        predic=Answer(user_symptoms)
        rest=""
        rest+=symp
        rest+=predic
        fulfillmentText = rest
        del User_Symptoms[sessionid]
        return {
            "fulfillmentText": fulfillmentText
        }
def Answer(user_symptoms):
    top3=Modelspred(user_symptoms)
    result=""
    result+="According to my predictions"+"\n"
    for i in top3:
        result+=info(i[0],i[1])
    result+="Major Disease "+top3[0][0]+"\n"
    result+=precau(top3[0][0])
    return result
     
def Modelspred(user_symptoms):
    rfc=pickle.load(open('Random_forest.pkl','rb'))
    top3_rfc=top3_models(rfc,user_symptoms)
    sgd=pickle.load(open('SGDmodel.pkl','rb'))
    top3_sgd=top3_models(sgd,user_symptoms)
    mlp=pickle.load(open('MLPmodel.pkl','rb'))
    top3_mlp=top3_models(mlp,user_symptoms)
    mnb=pickle.load(open('mnb.pkl','rb'))
    top3_mnb=top3_models(mnb,user_symptoms)
    
    top3=[]
    disease=[]
    disease+=top3_mnb
    disease+=top3_sgd
    disease+=top3_rfc
    disease+=top3_mlp
    dis=[]
    max={}
    for i in disease:
        dis.append(i[0])
    for k in set(dis):
        max[k]=dis.count(k)
    max = OrderedDict(sorted(max.items(), key=lambda kv: (kv[1],kv[0]), reverse=True))
    top=[]
    for i,j in zip(max,range(3)):
        top.append([i])
    for i in range(3):
        avg=0.0
        avg_count=0
        for j in disease:
            if j[0]==top[i][0]:
                avg+=j[1]
                avg_count+=1
        top[i].append(avg/avg_count)  
    diction={}
    for i in top:
        diction[i[0]]=i[1]   
    diction = OrderedDict(sorted(diction.items(), key=lambda kv: (kv[1],kv[0]), reverse=True))
    for i in diction:
        lis=[]
        lis.append(i)
        lis.append(diction[i])
        top3.append(lis)
    return top3

    
def top3_models(model_name,user_symptoms):
    model_name_symptom=np.zeros([132],dtype=float)
    l=model_name.classes_.tolist()
    m=[]
    for i in range(len(model_symptoms)):
        if model_symptoms[i] in user_symptoms:
            m.append(i)
    for i in m:
        model_name_symptom[i]=1
    probab=model_name.predict_proba([model_name_symptom]).tolist()
    top3_model_name=[]
    for j in range(3):
        max=-100000000
        h=0
        for i in range(len(probab[0])):
            if probab[0][i]>max:
                max=probab[0][i]
                h=i 
        k=[]
        k.append(l[h])
        k.append(probab[0][h]*100)
        top3_model_name.append(k)
        probab[0][h]=-1  
    return top3_model_name   

def status(value):
    if value>35:
        return 'high'
    elif value>15:
        return 'medium'
    else:
        return 'low'
    
def info(dise,value):
    infor=""
    val=status(value)
    ind=information_ofD.index(dise.strip())
    infor+="Disease:- "+dise+"\n"
    infor+="Probability:- "+val+"\n"
    if information_ofD[ind+1]!='nil':
        infor+="Common Name:- "+information_ofD[ind+1]+"\n"
    return infor        
 
def precau(dise):
    precaut=""
    if dise.strip() in Serious_Diseases:
        precaut+="You should consult a doctor"
        ind=information_ofD.index(dise.strip())
        if information_ofD[ind+2]!='nil':
            precaut+="\nType:-"+information_ofD[ind+2]
    else:
        precautions=pd.read_csv("symptom_precaution.csv")
        precautions.columns=precautions.columns.str.replace('_',' ')
        precaut+="You can take following Primary Precautions "+"\n"
        for i in range(len(precautions['Disease'])):
            if precautions['Disease'][i].strip()==dise.strip():
                for k in range(4):
                    precaut+=str(precautions['Precaution '+str(k+1)][i])+"\n"
    return precaut    
    
    
if __name__ == '__main__':
    app.run()
