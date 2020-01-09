--宵星の機神ディンギルス
function c93854893.initial_effect(c)
	c:SetSPSummonOnce(93854893)
	--xyz summon
	aux.AddXyzProcedure(c,nil,8,2,c93854893.ovfilter,aux.Stringid(93854893,0))
	c:EnableReviveLimit()
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c93854893.tg)
	e1:SetOperation(c93854893.op)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c93854893.desreptg)
	e2:SetValue(c93854893.desrepval)
	e2:SetOperation(c93854893.desrepop)
	c:RegisterEffect(e2)
end
function c93854893.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x11b) and c:IsType(TYPE_LINK)
end
function c93854893.ofilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_MONSTER) and c:IsCanOverlay()
end
function c93854893.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil)
	local b2=Duel.IsExistingMatchingCard(c93854893.ofilter,tp,LOCATION_REMOVED,0,1,nil)
	if chk==0 then return b1 or b2 end
	local off=1
	local ops,opval={},{}
	if b1 then
		ops[off]=aux.Stringid(93854893,1)
		opval[off]=0
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(93854893,2)
		opval[off]=1
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))+1
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==0 then
		e:SetCategory(CATEGORY_TOGRAVE)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_ONFIELD)
	else
		e:SetCategory(0)
	end
end
function c93854893.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if sel==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	else
		if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,c93854893.ofilter,tp,LOCATION_REMOVED,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.Overlay(c,g)
		end
	end
end
function c93854893.repfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c93854893.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c93854893.repfilter,1,nil,tp)
		and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c93854893.desrepval(e,c)
	return c93854893.repfilter(c,e:GetHandlerPlayer())
end
function c93854893.desrepop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	Duel.Hint(HINT_CARD,0,93854893)
end
