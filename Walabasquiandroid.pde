int time;
float[] x, y, z;
static int MAX_TARGETS = 3;
static int WOBBLE = 5;

void setup() {
  //size(1920,1080);
  fullScreen();
  
  background(#242424);
  //noStroke();
  stroke(#242424);

  time = 0;
  
  x = new float[MAX_TARGETS];
  y = new float[MAX_TARGETS];
  z = new float[MAX_TARGETS];
  
  for(int i = 0 ; i < MAX_TARGETS; i++) {
    x[i] = width / 2;
    y[i] = height / 2;
    z[i] = random(30.0, 70.0);
  }
  
}

void loadJSONData() {
  
  String[] json = loadStrings("http://192.168.1.69:5000/walabot/api/v1.0/sensortargets");
  for(String s: json){
    println(s);
  }

  saveStrings("data.json", json);

  JSONObject jobj =  loadJSONObject("data.json");
  JSONArray targetsJSONArray = jobj.getJSONArray("sensortargets");
  
  for(int i = 0 ; i < targetsJSONArray.size(); i++){
    
    JSONObject eventObject = targetsJSONArray.getJSONObject(i);
     
    x[i] = eventObject.getFloat("xPosCm");
    y[i] = eventObject.getFloat("yPosCm");
    z[i] = eventObject.getFloat("zPosCm");
    
    // translate from Walabot Cartesian coordinates to pixels, and adjust for screen size
    x[i] = (width / 2) + ((x[i] / 100.0) * width);
    y[i] = (height / 2) + ((y[i] / 100.0) * height);
    z[i] = z[i] * 10;
    
    
    // debug
    println("x[" + i + "]: " + x[i] );
    println("y[" + i + "]: " + y[i] );
    println("z[" + i + "]: " + z[i] );
    
  }
  
}

float wiggle(float original) {
  return original + random(-1 * WOBBLE, WOBBLE);
}
  
void draw() {
  
  if (millis() > time) {
  
    time = time + 3000;
    
    thread("loadJSONData");
    
  }
  
  for(int i = 0; i < MAX_TARGETS; i++) {
    
    // wiggle each dimension
    x[i] = wiggle(x[i]);
    y[i] = wiggle(y[i]);
    z[i] = wiggle(z[i]);
    
    if (i % 3 == 0) {
      fill(x[i] % 256, y[i] % 256, z[i] % 256);
    } else if (i % 3 == 1) {
      fill(y[i] % 256, z[i] % 256, x[i] % 256);      
    } else {
      fill(z[i] % 256, x[i] % 256, y[i] % 256);
    }
    
    ellipse(x[i], y[i], z[i], z[i]);
  }
}
