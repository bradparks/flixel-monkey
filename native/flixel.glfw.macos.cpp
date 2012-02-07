
#include <time.h>
#include <math.h>

class flixel {

public:

	static int systemMillisecs() {
		double n;
		time_t t;
		struct tm * timeinfo;		
		time(&t);
		timeinfo = localtime(&t);
		int seconds = (timeinfo->tm_sec + timeinfo->tm_min * 60 + timeinfo->tm_hour * 3600);
		return  (seconds + modf(glfwGetTime(), &n)) * 1000;
	}
	
	static void showMouse() {
		glfwEnable(GLFW_MOUSE_CURSOR);
	}
	
	static void hideMouse() {
		glfwDisable(GLFW_MOUSE_CURSOR);
	}
	
	static bool isMobile() {
		return false;
	}
	
};