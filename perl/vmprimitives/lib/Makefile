# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2016 Software Assurance Marketplace


tidy: VMPrimitives.pm
	perl -c $<
	perltidy $< && mv $(<).tdy $<
