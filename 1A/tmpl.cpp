#include <cstdio>
#include <cmath>
#include <ctime>
#include <memory.h>
#include <vector>
#include <set>
#include <map>
#include <algorithm>
#include <assert.h>
#include <string>
#include <limits.h>

using namespace std;

#define FOR(i, e) for(int i = 0; i < (e); i++)
#define FORS(i, s, e) for(int i = (s); i < (e); i++)
#define ALL(c) c.begin(), c.end()

typedef long long ll;
typedef vector<int> vi;
typedef vector<double> vd;
typedef vector<string> vs;

int ri(){ int value; scanf("%d", &value); return value; }
ll rl(){ ll value; scanf("%lld", &value); return value; }
double rd(){ double value; scanf("%lf", &value); return value; }
string rs(){ char buf[10000]; scanf("%s", buf); return buf; }
template<class T> void sort(T& c){ sort(c.begin(), c.end()); }
template<class T> void rsort(T& c){ sort(c.begin(), c.end()); reverse(c.begin(), c.end()); }

#ifdef LOCAL
	#define ppd(...) printf(__VA_ARGS__)
#else
	#define ppd(...)
#endif

int main()
{
#ifdef LOCAL
	time_t start;
	time(&start);
#endif
	// --------------------------------------

	// --------------------------------------
#ifdef LOCAL
	time_t end;
	time(&end);
	printf("%ld sec.\n", end - start);
#endif
	return 0;
}
