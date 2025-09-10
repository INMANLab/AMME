function DisplayPatientStructInfo(patient)



pList = string(vertcat(patient.name));
disp("Total Number of participants:"+ length(pList));

for pIdx = 1:length(pList)
    disp("================================================================")
    disp("Patient: "+string(patient(pIdx).name)+" "+pIdx+"/"+length(pList))
    for phIdx = 1:length(patient(pIdx).phase)
        if(isempty(patient(pIdx).phase(phIdx).Results))
            continue;
        end
        disp("-------------Phase:"+phIdx)
        disp("--->Fields in trial:")
        disp(convertCharsToStrings(fields(patient(pIdx).phase(phIdx).trial)))
        disp("--->Available Measures:")
        disp(unique(patient(pIdx).phase(phIdx).Results.Measure))
        disp("--->Available Regions:")
        disp(unique(patient(pIdx).phase(phIdx).Results.Region))
    end
end
