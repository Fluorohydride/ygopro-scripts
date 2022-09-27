--破壊の代行者 ヴィーナス
function c99054885.initial_effect(c)
	--self spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99054885,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,99054885)
	e1:SetCost(c99054885.sscost)
	e1:SetTarget(c99054885.sstg)
	e1:SetOperation(c99054885.ssop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99054885,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,99054885)
	e2:SetCost(c99054885.spcost)
	e2:SetTarget(c99054885.sptg)
	e2:SetOperation(c99054885.spop)
	c:RegisterEffect(e2)
end
function c99054885.ssfilter(c)
	return c:IsCode(64734921) and c:IsAbleToRemoveAsCost()
end
function c99054885.sscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99054885.ssfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c99054885.ssfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c99054885.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c99054885.ssop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c99054885.spfilter(c,e,tp)
	return c:IsCode(39552864) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and c:IsCanBeEffectTarget(e) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c99054885.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return Duel.CheckLPCost(tp,500,true) and ft>0 end
	local lp=Duel.GetLP(tp)
	local g=Duel.GetMatchingGroup(c99054885.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
	local ct=g:GetCount()
	if ct>ft then ct=ft end
	if ct>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	local t={}
	for i=1,ct do
		if not Duel.CheckLPCost(tp,i*500,true) then break end
		t[i]=i
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99054885,2))
	local announce=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.PayLPCost(tp,announce*500,true)
	e:SetLabel(announce)
end
function c99054885.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and c99054885.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c99054885.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c99054885.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,ct,ct,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c99054885.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if sg:GetCount()>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		sg=sg:Select(tp,ft,ft,nil)
	end
	local tc=sg:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_DECKBOT)
		tc:RegisterEffect(e1)
		tc=sg:GetNext()
	end
	Duel.SpecialSummonComplete()
end
