#include <stddef.h>
#include <stdbool.h>
#include "ll_cycle.h"


int ll_has_cycle(node *head) {
    if (!head) return 0;
    
    int i;
    bool vis[25];
    node *p = head;
    for (i = 0; i < sizeof(vis)/sizeof(bool); i++)
        vis[i] = false;
    
    while (p != NULL) {
        // printf("%d ", p->value);
        if (vis[p->value]) return 1;
        vis[p->value] = true;
        p = p->next;
    }

    return 0;
}
