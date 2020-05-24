int L,R,px,py,bx,by;//variable para controlar el movimiento
int dx=1,dy=-1;
int vx=4, vy=3;
int estado=2;//estado de movimiento
int rand;
color c;

int vidas,caer,rebotar,sacar, puntos, victoria;//variable controlar el juego
int i,j;//contador
int[][]duracion=new int[500][500];// una determinante para la duración de los ladrillos

int menu; // para el menú
int inicio;



void setup()
{
  size(700,500);// Establece la pantalla
  background(255);//fondo blanco
  
  //asignación de los variables
  L = 90;
  R = 20;
  inicio = 1;
        
}

void draw()
{
  if(inicio == 1) //menú
  {
    if(menu == 0)
    {
    int xp,yp,xb,yb;
    delay(100);
    
    xp = width/2;
    yp = height/2;
    xb = xp + L/2;
    yb = yp - R/2;
    
    
    fill(0); //dibujar el logo
    rect(0,0,width,height);
    textSize(80);
    fill(48,13,255);
    text("Sparkanoid",width/2-height/2,L+R);
    
    
    rect(xp,yp,L,R);
    ellipse(xb,yb,R,R);
     
    textSize(20);
    fill(random(100,150));
    text("PULSA TECLADO ESPACIO PARA CONTINUAR",L+R,height-L+R);
    
    if(keyPressed == true) // si pulsa algún teclado
      {
        if(key == ' ')
        menu=1; //menú de dificultad
      }
    }
    else
     if(menu==1)
     {
       fill(0);//explicaciones
       rect(0,0,width,height);
       textSize(50);
       fill(48,13,255);
       text("Seleccionar el modo",width/2-height/2-R,L+R);
       textSize(30);
       text("A- NORMAL",width/2-height/2+R,L+L/2+R);
       text("B- DIFÍCIL",width/2-height/2+R,L*2+R);
       text("C- EXTREMO",width/2-height/2+R,L*2+R*3);
       text("P- SALIR",width/2-height/2+R,L*2+R*5);
       
       fill(235,33,89);
       text("CONTROLES:",width/2-height/2-R,L*2+R*9); // tutoria
       textSize(15);
       text("-Tecla A para desplazar hacia izquierda",width/2-height/2+R,L*2+R*11);
       text("-Tecla D para desplazar hacia derecha",width/2-height/2+R,L*2+R*12);
       text("-Tecla R para sacar la bola",width/2-height/2+R,L*2+R*13);
       condicion();
     }
  }
  else
  {
  fill(0);
  rect(0,0,height,height);// establece un fondo negro para ver mejor los movimiento
  
  fill(255);
  rect(height,0,width-height,height);// una menú del fondo blanco
  
  d_muros(0,height);// dibujar muros
  m_pla(); //establece la plataforma y pelota y controles
  m_ladrillo(); //establece ladrillo y controlar
  
  if(vidas>3)// cambiar el color de número según el oportunnidad restante
   c = color(0,255,0);
    else
     if(vidas>2)
      c = color(255,199,13);
       else
        if(vidas>1)
         c = color(255,94,13);
          else
           c = color(255,13,13);
  
  textSize(40);//mostrar la oportunidad restante
  fill(0);
  text("VIDAS:",530,50);
  textSize(70);
  fill(c);
  text(vidas,570,140);
  
  textSize(25);
  fill(0);
  text("PUNTUACIÓN:",515,200);// mostrar la puntuación
  textSize(35);
  fill(150);
  text(puntos,580,260);
  
  if(sacar == 0)//si esta sacado la bola
  {
    bx=m_bolax();// para x de la bola
    by=m_bolay();// para y de la bola
    romper_ladrillo();// para romper los ladrillos
    caer = caida(); // para determinar si esta caido o no
  }
  
  if(caer ==1)// si había caido la bola
  {
    sacar = 1;// empezar a sacar
    bx = px+L/2;// reposicionar la bola
    by = py- R/2;
    dx = 1; // reposicionar la dirección
    dy = -1;
    vidas--; //castigo
    puntos = puntos - 2; 
    caer = 0;
    }
    
    if((dx>0)&&(dy>0)) // para determinar el estado del dirección
      estado=0;
      else
       if((dx<0)&&(dy>0))
         estado=1;
           
  if(vidas == 0)// fin del partido 
    {
      String s ="GAME OVER";
      textSize(30);
      fill(50);
      text(s,520,400);
      fill(255);
      text("Pulsa tecla m para volver al título",10,L*2+R*10);
      if(keyPressed == true) // pulsa tecla m para volver al menú
      {
        switch(key)
        {
          case 'm':
          case 'M':inicio = 1;
                   menu = 0;
                   break;
        }
      }
    }
    
    victoria = vic(); // fin del partido
    if (victoria ==1)
    {
      bx = px+L/2;// reposicionar la bola
      by = py- R/2;
      sacar = 1;
      textSize(25);
      fill(50);
      text("ENHORABUENA",510,400);
      fill(255);
      text("Pulsa tecla m para volver al título",10,L*2+R*10);
      if(keyPressed == true)// pulsa tecla m para volver al menú
      {
        switch(key)
        {
          case 'm':
          case 'M':inicio = 1;
                   menu = 0;
                   break;
        }
      }
    }
}
}  

void d_muros(int n,int x)// una función establece el muro
{
 strokeWeight(4);// grosor 5
 stroke(98,109,100);// color verde
 line(n,n,n,x);//lateral
 line(n,n,x,n);//superior
 line(x,n,x,x);//lateral
 line(n,x,x,x);//inferior
}

void m_pla()// una función controlar los movimiento 
{ 
  
  strokeWeight(0);// plataforma
  stroke(12,247,135);
  fill(195,175,255);
  rect(px,py,L,R);
  
  fill(255,190,192);// bola
  ellipse(bx,by,R,R);
  
  if(vidas>0 && victoria==0) //si hay vida
    if(caer != 1) //si no ha caido la bola
    {
      if(keyPressed==true) // si ha pulsado una teclado
      {
        switch(key)// según el teclado 
        {
          case 'a':// si pulsa a
          case 'A':if((px > 0) && (px < height-L))//si esta dentro del muro
                    {
                    px = px - 4;//se mueve hacia izquierda
                    if(sacar ==1)//si la pelota este en la plataforma
                    bx = bx - 4;
                    }
                     else
                      if(px >= height-L)//si esta en el muro lateral derecha
                       {
                         px = px - 4;
                        if(sacar ==1)
                         bx = bx - 4;
                        }
                       else//si no es ninguno de los casos
                        {
                          px = px - 0;
                          if(sacar ==1)
                          bx = bx - 0;
                         }
                    
                   break;
          case 'd':// si pulsa b
          case 'D':if((px>0) && (px<height-L))//mientra este en el muro
                    {
                      px=px + 4;//se mueve hacia derecha
                      if(sacar ==1)
                      bx = bx + 4;
                    }
                    else
                    if(px <= 0)// si llegar al muro izquierdad
                    {
                         px = px + 4;
                        if(sacar ==1)
                         bx = bx + 4;
                     }
                       else
                        {
                          px = px+0;
                          if(sacar ==1)
                          bx = bx+0;
                         }
          
                   break;
           case 'r'://si pulsa r
           case 'R':if(sacar == 1)// saca la bola
                    {
                     sacar = 0; 
                    }
                    break;
          
        }
      }
    }
}

void m_ladrillo(){ //dibujar los ladrillos
  for(i=40;i<=height-3*R;i=i+46)// establece los ladrillos
    for(j=40;j<=160;j=j+20)
    {
      if(duracion[i][j]>1)// si la duración es mayor que 1
      {
        fill(242,194,34);
        strokeWeight(2);// color dolado
        stroke(255);
        rect(i,j,46,20);
      }
      
      else// si el ladrillo no este roto
       if(duracion[i][j]>0)
      {
      if(j<=40)
      fill(229,102,85); //color rojo
      else
      if(j<=60)
       fill(17,132,206); // color azul
       else
        if(j<=80)
         fill(239,50,250);// rosa
         else
         if(j<=100)
          fill(122,29,90);//morado
          else
          if(j<=120)
           fill(42,183,0);//verde
           else
           if(j<=140)
            fill(245,238,32);//amarillo
            else
            fill(2,214,157);//cian
      strokeWeight(2);
      stroke(255);
      rect(i,j,46,20);
    }
    }
}

int m_bolax()// controla movimiento de la bola en el eje x
{
  int x;
  x=bx;  
  x += vx * dx;//x es igual el producto de la dirección por la velocidad sumando x
  if ((x > height-R) || (x < R))//si choca contra el muro
   dx = -dx;//se rebota
  
  if((by+R>=py) && (by+R<py+R/2))// si choca contra la plataforma
    if((bx>=px) && (bx<=px+L))
      if(estado==1)//se rebota
        {
          if(dx>0)
           dx = -dx;
           else
           dx = dx+0;
        }
      else
        {
          if(dx>0)
           dx = dx+0;
           else
           dx = -dx;
         }
   
   
   
  return x;
}

int m_bolay()//movimiento en el eje y
{
  int y;
  y = by;
  
  y += vy * dy;//y es igual el producto de la dirección por la velocidad luego suman y
  if ((y > height-R) || (y < R))// si choca contra el muro
   {
     dy = -dy;// se rebota
     rebotar--;
   }
   
   if((by+R>=py)&&(by+R<py+R/2))//si choca contra la plataforma
    if((bx>=px) && (bx<=px+L))
    if(estado==1)//se rebota
      {
      if(dy<0)
       dy = dy+0;// se rebota
       else
        dy = -dy;
      }
      else
      {
       if(dy<0)
        dy = dy+0;// se rebota
        else
         dy = -dy;
      }
  return y;
}

int caida()// función para controlar si la bola había caido o no
{
  int c;
  if(by+R>=height-R/2)//si la bola llega al muro inferior
  c = 1;//había caido
  else//sino
  c = 0;//no había caido
  return c;
}

void romper_ladrillo()// función para romper los ladrillos
{
  for(i=40;i<=height-3*R;i=i+46)// si choca contra alguno de los ladrillos
    for(j=40;j<=160;j=j+20)
       if((i<bx+R)&&(i+46>bx+R)||((i>bx)&&(i<bx+R))||((i+46>bx-R))&&(i+46<bx))
         if(((j>=by+R)&&(j+R/2<=by+R))||((j+20<=by)&&(j+20+R/2>=by))||((by-R<j)&&(by+R>j)&&(by>=j)&&(by<j+20))||(by-R<j+20)&&(by+R>j+20)&&(by>j)&&(by<=j+20))// localizar ladrillo
           if(duracion[i][j]>0)// si el ladrillos no esté roto
           {
               duracion[i][j]=duracion[i][j]-1;// resta la duración del ladrillos
               rebotar++;
               puntos++;// aumenta la puntuación
               rand=(int)random(4);//dar más alteración al movimiento
               
               
               switch(rand)// según el caso cambia el movimiento
               {
                case 1:dx = -dx;
                       dy = -dy;
                       vx = (int)random(3,5);
                       vy = (int)random(2,4);
                       break;
                       
                case 2:if(rebotar<4)// si rebotado menos de 4 veces
                       {
                        dx = dx * 1;
                        dy = -dy;
                        vx = (int)random(3,5);
                        vy = (int)random(2,4);
                       }
                       else
                        {
                          dx = -dx;
                          dy = -dy;
                          vy = 3;
                          rebotar = 0;
                        }
                       break;
                case 3:if(rebotar<4)// si rebotado menos de 4 veces
                       {
                       dx = -dx;
                       dy = dy * 1;
                       vx = (int)random(3,5);
                       vy = (int)random(3,4);
                       }
                       else
                        {
                          dx = -dx;
                          dy = -dy;
                          vy = 3;
                          rebotar = 0;
                        }
                       break;
               }
           }   
}

int vic() // Función para controla la partida
{
  int v=1;
  int c=0;
  for(i=40;i<=height-3*R;i=i+46)// si choca contra alguno de los ladrillos
    for(j=40;j<=160;j=j+20)
      {
        c = c + duracion[i][j]; // sumar los valores de todos los ladrillo 
      }
      if (c>0) // si no dá 0
       v = 0; // no esta finalizado
       else //sino
        v = 1;// esta finalizado
  return v;
}

void condicion()// Una función para establece los condición inicial
{
  if(keyPressed == true)
   {
     switch(key)
     {
       case 'a':
       case 'A':vidas = 4;//4 oportunidades
                for(i=40;i<=height-3*R;i=i+46)// establece la duración ladrillos
                 for(j=40;j<=160;j=j+20)
                  duracion[i][j]=1; // hay que chocar una veces contra ladrillo
                  puntos = 0;
                  dx=1;
                  dy=-1;
                  rebotar = 0;
                  sacar = 1;
                  caer = 0;
                  victoria = 0;
                  px = width/2-L*2;
                  py = height - L;
                  bx = px+L/2;
                  by = py- R/2;
                inicio = 0;
                break;
       case 'b':
       case 'B':vidas = 4;//4 oportunidades
                for(i=40;i<=height-3*R;i=i+46)// establece la duración ladrillos
                 for(j=40;j<=160;j=j+20)
                  duracion[i][j]=2; // hay que chocar dos veces contra ladrillo
                  puntos = 0;
                   dx=1;
                  dy=-1;
                  rebotar = 0;
                  sacar = 1;
                  caer = 0;
                  victoria = 0;
                  px = width/2-L*2;
                  py = height - L;
                  bx = px+L/2;
                  by = py- R/2;
                inicio = 0;
                break;
       case 'c':
       case 'C':vidas = 1;//1 oportunidad
                for(i=40;i<=height-3*R;i=i+46)// establece la duración ladrillos
                 for(j=40;j<=160;j=j+20)
                  duracion[i][j]=2; // hay que chocar dos veces contra ladrillo
                  puntos = 0; // eliminar los puntos
                   dx=1; // dirección x
                  dy=-1; // dirección y
                  rebotar = 0; // limpiar valor de rebotar
                  sacar = 1; // empezar a sacar
                  caer = 0; //no esté caido la bola
                  victoria = 0;
                  px = width/2-L*2; //coordenada iniciales
                  py = height - L;
                  bx = px+L/2;
                  by = py- R/2;
                inicio = 0;
                break;
        case 'p':
        case 'P':exit(); //salir de la programa
                 break;
     }
   }
}
