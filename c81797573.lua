--Angelechy Enlisted
local s,id,o=GetID()
function s.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1,1)
	c:EnableReviveLimit()
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.rmtg)
	e1:SetOperation(s.rmop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOEXTRA)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_CONTROL_CHANGED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
function s.rmfilter(c,ec,tp)
	local seq1=aux.MZoneSequence(c:GetSequence())
	local seq2=aux.MZoneSequence(ec:GetSequence())
	local seq3=4-seq2
	local zone=0
	if seq3>0 then
		zone=bit.bor(zone,1<<(seq3-1))
	end
	if seq3<4 then
		zone=bit.bor(zone,1<<(seq3+1))
	end
	return math.abs(4-seq1-seq2)==1 and c:IsAbleToRemove()
		and Duel.GetMZoneCount(1-tp,c,1-tp,LOCATION_REASON_CONTROL,zone)>0
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and s.rmfilter(chkc,c,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.rmfilter,tp,0,LOCATION_MZONE,1,nil,c,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,s.rmfilter,tp,0,LOCATION_MZONE,1,1,nil,c,tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() and tc:IsType(TYPE_MONSTER)
		and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0
		and c:IsRelateToChain() then
		local seq=4-aux.MZoneSequence(c:GetSequence())
		local zone=0
		if seq>0 then
			zone=bit.bor(zone,1<<(seq-1))
		end
		if seq<4 then
			zone=bit.bor(zone,1<<(seq+1))
		end
		Duel.GetControl(c,1-tp,0,0,zone)
	end
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	return eg:IsContains(c) and c:IsFaceup()
end
function s.spfilter(c,e,tp,cp)
	return c:IsSetCard(0x1e2) and c:IsCanBeSpecialSummoned(e,0,cp,false,false,POS_FACEUP,cp)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,c:GetOwner(),LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0
		and c:IsLocation(LOCATION_EXTRA) then
		local p=c:GetOwner()
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(p,s.spfilter,p,LOCATION_EXTRA,0,1,1,nil,e,p,p)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SpecialSummon(g,0,p,p,false,false,POS_FACEUP)
		end
	end
end
