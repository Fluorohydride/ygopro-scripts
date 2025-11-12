--トポロジック・ブラスター・ドラゴン
local s,id,o=GetID()
function s.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)
	c:EnableReviveLimit()
	--zone limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_MUST_USE_MZONE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetValue(s.zonelimit)
	c:RegisterEffect(e1)
	--effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetCondition(s.econ)
	e2:SetTarget(s.etg)
	e2:SetOperation(s.eop)
	c:RegisterEffect(e2)
end
function s.zonelimit(e)
	return 0x1f001f | (0x600060 & ~e:GetHandler():GetLinkedZone())
end
function s.cfilter(c,zone)
	local seq=c:GetSequence()
	if c:IsLocation(LOCATION_MZONE) then
		if c:IsControler(1) then seq=seq+16 end
	else
		seq=c:GetPreviousSequence()
		if c:IsPreviousControler(1) then seq=seq+16 end
	end
	return bit.extract(zone,seq)~=0
end
function s.econ(e,tp,eg,ep,ev,re,r,rp)
	local zone=Duel.GetLinkedZone(0)+(Duel.GetLinkedZone(1)<<0x10)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(s.cfilter,1,nil,zone) and e:GetHandler():GetSequence()>4
end
function s.tdfilter(c)
	return c:IsAbleToDeck() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function s.etg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler())
		or Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		or Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,1,nil) end
end
function s.eop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_MZONE,LOCATION_MZONE,1,aux.ExceptThisCard(e))
		and Duel.GetFlagEffect(tp,id)==0
	local b2=Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and Duel.GetFlagEffect(tp,id+o)==0
	local b3=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,1,nil)
		and Duel.GetFlagEffect(tp,id+o*2)==0
	if not (b1 or b2 or b3) then return end
	local op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(id,1),1},
			{b2,aux.Stringid(id,2),2},
			{b3,aux.Stringid(id,3),3})
	if op==1 then
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
		local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_MZONE,LOCATION_MZONE,aux.ExceptThisCard(e))
		if g:GetCount()>0 then
			Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
	elseif op==2 then
		Duel.RegisterFlagEffect(tp,id+o,RESET_PHASE+PHASE_END,0,1)
		local g=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		if g:GetCount()>0 then
			Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
	elseif op==3 then
		Duel.RegisterFlagEffect(tp,id+o*2,RESET_PHASE+PHASE_END,0,1)
		local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.ConfirmCards(tp,g,true)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local tg=g:FilterSelect(tp,Card.IsAbleToRemove,1,1,nil)
			if tg:GetCount()>0 then
				Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
			end
			Duel.ShuffleExtra(1-tp)
		end
	end
end
