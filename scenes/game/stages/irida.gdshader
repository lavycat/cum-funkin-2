shader_type canvas_item;
// TODO: FIX THIS WHOLE SHADER

#define rot(x) mat2(cos(x+vec2(0,11)),cos(x+vec2(33,0)))
//Rodrigues-Euler axis angle rotation
#define ROT(p,axis,t) mix(axis*dot(p,axis),p,cos(t))+sin(t)*cross(p,axis)

//formula for creating colors;
#define H(h)  (  cos(  h + vec3(15,11,16.5)   )*.6 + .5 )

#define H2(h)  (  cos(  h*h/3. + vec3(5,2,2)   )*.7 + .2 )

//formula for mapping scale factor 
#define M(c)  log(1.+c)

#define R iResolution



#define iterations 17
#define formuparam 0.53

#define volsteps 20
#define stepsize 0.1

#define zoom   0.800
#define tile   0.850
#define speed  0.000 

#define brightness 0.0015
#define darkmatter 0.300
#define distfading 0.730
#define saturation 0.850
void mainVR( out vec4 fragColor, in vec2 fragCoord, in vec3 ro, in vec3 rd )
{
	//get coords and direction
	vec3 dir=rd;
	vec3 from=ro;
	
	//volumetric rendering
	float s=0.1,fade=1.;
	vec3 v=vec3(0.);
	for (int r=0; r<volsteps; r++) {
		vec3 p=from+s*dir*.5;
		p = abs(vec3(tile)-mod(p,vec3(tile*2.))); // tiling fold
		float pa,a=pa=0.;
		for (int i=0; i<iterations; i++) { 
			p=abs(p)/dot(p,p)-formuparam;
                p.xy *= rot(TIME*0.05);// the magic formula
			a+=abs(length(p)-pa); // absolute sum of average change
			pa=length(p);
		}
		float dm=max(0.,darkmatter-a*a*.001); //dark matter
		a*=a*a; // add contrast
		if (r>6) fade*=1.3-dm; // dark matter, don't render near
		//v+=vec3(dm,dm*.5,0.);
		v+=fade;
		v+=vec3(s,s*s,s*s*s*s)*a*brightness*fade; // coloring based on distance
		fade*=distfading; // distance fading
		s+=stepsize;
	}
	v=mix(vec3(length(v)),v,saturation); //color adjust
	fragColor = vec4(v*.08,1.);	
}
float happy_star(vec2 uv, float anim)
{
    uv = abs(uv);
    vec2 pos = min(uv.xy/uv.yx, anim);
    float p = (2.0 - pos.x - pos.y);
    return (2.0+p*(p*p-1.5)) / (uv.x+uv.y);      
}
void fragment()
{
	//get coords and direction
	vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
	vec2 uv=FRAGCOORD.xy/iResolution.xy-.5;
    vec2 uv2=FRAGCOORD.xy/iResolution.xy-.5;
	uv.y*=iResolution.y/iResolution.x;
	vec3 dir=vec3(uv*zoom,1.);
    float t2 = TIME * .1 + ((.25 + .05 * sin(TIME * .1))/(length(uv.xy) + .07)) * 2.2;
	float si = sin(t2);
	float co = cos(t2);
	mat2 ma = mat2(vec2(co,si), vec2(-si, co));

	float time=TIME*speed+1.5;
vec4 O =COLOR;
vec2 U =FRAGCOORD.xy;
	  O = vec4(0);
    uv2.x+=0.2;
    uv2.y+=0.2;
    vec3 c=vec3(0);
    vec4 rd = normalize( vec4(U-.5*R.xy, R.y, R.y*2.))*80.;
    
    float sc,dotp,totdist=0., t=.7, tt=TIME/4.;
    
    for (float i=0.; i<200.; i++) {
        
        vec4 p = vec4( rd*totdist);
            
        p.xyz += vec3(0,0,-1.7);
        
           
        p.yzw = ROT(p.xyz, normalize( vec3(sin(t/2.), sin(t), cos(t/3.) )  ),t);

        sc = 1.1; 
        
     p.xy*=ma;
  
        
        vec4 w = p;
        
        for (float j=0.; j<7.; j++) {
          
            p = abs(p)*.77;
          
            dotp = max(1./dot(w,w),.1);
            
            sc *= dotp; 
            
            p = p * dotp - .42 ;
            
            w = .75*p - .025 ;
            
     
        }
         
        float dist = abs( length(p)-.025)/sc ;  //funky distance estimate
        float stepsize2 = dist/15. ;     
        totdist += stepsize2;              //move the distance along rd
        
        //accumulate color, fading with distance and iteration count
        c +=
             3e-3* H2(  atan( p.w, p.z )) + 
             + mix( vec3(1), H(M(sc)),.95) *.03*  exp(-i*i*stepsize2*stepsize2*8e3);
    }
    
    c = 1. - exp(-c*c);
	
	vec3 from=vec3(1.,.9,1.5);
	dir+=c;
	
	mainVR(COLOR, FRAGCOORD.xy, from, dir);
    COLOR*=vec4(c,1.);
     uv *= 2.0 * ( cos(TIME * 2.0) -2.5); // scale
    float anim = sin(TIME * 12.0) * 0.1 + 1.0;  // anim between 0.9 - 1.1 
    COLOR*= vec4(happy_star(uv, anim) * vec3(0.35,1.0,1.55), 1.0);
    
}
