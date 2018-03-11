/*
 * Copyright (c) 2009-2011 Apple Inc. All rights reserved.
 *
 * @APPLE_APACHE_LICENSE_HEADER_START@
 */

/*
 * IMPORTANT: This header file describes INTERNAL interfaces to libdispatch
 * which are subject to change in future releases of Mac OS X. Any applications
 * relying on these interfaces WILL break.
 */

#ifndef __DISPATCH_DATA_INTERNAL__
#define __DISPATCH_DATA_INTERNAL__

#ifndef __DISPATCH_INDIRECT__
#error "Please #include <dispatch/dispatch.h> instead of this file directly."
#include <dispatch/base.h> // for HeaderDoc
#endif

struct dispatch_data_vtable_s {
	DISPATCH_VTABLE_HEADER(dispatch_data_s);
};

extern const struct dispatch_data_vtable_s _dispatch_data_vtable;

typedef struct range_record_s {
	void* data_object;
	size_t from;
	size_t length;
} range_record;

struct dispatch_data_s {
	DISPATCH_STRUCT_HEADER(dispatch_data_s, dispatch_data_vtable_s);
#if DISPATCH_DATA_MOVABLE
	unsigned int locked;
#endif
	bool leaf;
	dispatch_block_t destructor;
	size_t size, num_records;
	range_record records[];
};

#endif // __DISPATCH_DATA_INTERNAL__
