function cord_new=egocentricCoor(cord_old,cord_O,cord_P)

vector1=cord_P-cord_O;
vector2=cord_old-cord_O;

temp_cos=dot(vector1,vector2)/(norm(vector1)*norm(vector2));
temp_sin=cross([vector1,0],[vector2,0])/(norm(vector1)*norm(vector2));

cord_new=[temp_sin(1,3),temp_cos];
end