/* card marking write barrier. a card is a byte storing a mark flag,
and the offset (in cells) of the first object in the card.

the mark flag is set by the write barrier when an object in the
card has a slot written to.

the offset of the first object is set by the allocator. */

namespace factor
{

/* if CARD_POINTS_TO_NURSERY is set, CARD_POINTS_TO_AGING must also be set. */
#define CARD_POINTS_TO_NURSERY 0x80
#define CARD_POINTS_TO_AGING 0x40
#define CARD_MARK_MASK (CARD_POINTS_TO_NURSERY | CARD_POINTS_TO_AGING)
typedef u8 F_CARD;

#define CARD_BITS 8
#define CARD_SIZE (1<<CARD_BITS)
#define ADDR_CARD_MASK (CARD_SIZE-1)

VM_C_API CELL cards_offset;

#define ADDR_TO_CARD(a) (F_CARD*)(((CELL)(a) >> CARD_BITS) + cards_offset)
#define CARD_TO_ADDR(c) (CELL*)(((CELL)(c) - cards_offset)<<CARD_BITS)

typedef u8 F_DECK;

#define DECK_BITS (CARD_BITS + 10)
#define DECK_SIZE (1<<DECK_BITS)
#define ADDR_DECK_MASK (DECK_SIZE-1)

VM_C_API CELL decks_offset;

#define ADDR_TO_DECK(a) (F_DECK*)(((CELL)(a) >> DECK_BITS) + decks_offset)
#define DECK_TO_ADDR(c) (CELL*)(((CELL)(c) - decks_offset) << DECK_BITS)

#define DECK_TO_CARD(d) (F_CARD*)((((CELL)(d) - decks_offset) << (DECK_BITS - CARD_BITS)) + cards_offset)

#define ADDR_TO_ALLOT_MARKER(a) (F_CARD*)(((CELL)(a) >> CARD_BITS) + allot_markers_offset)
#define CARD_OFFSET(c) (*((c) - (CELL)data_heap->cards + (CELL)data_heap->allot_markers))

#define INVALID_ALLOT_MARKER 0xff

VM_C_API CELL allot_markers_offset;

/* the write barrier must be called any time we are potentially storing a
pointer from an older generation to a younger one */
inline static void write_barrier(F_OBJECT *address)
{
	*ADDR_TO_CARD(address) = CARD_MARK_MASK;
	*ADDR_TO_DECK(address) = CARD_MARK_MASK;
}

/* we need to remember the first object allocated in the card */
inline static void allot_barrier(F_OBJECT *address)
{
	F_CARD *ptr = ADDR_TO_ALLOT_MARKER(address);
	if(*ptr == INVALID_ALLOT_MARKER)
		*ptr = ((CELL)address & ADDR_CARD_MASK);
}

}
