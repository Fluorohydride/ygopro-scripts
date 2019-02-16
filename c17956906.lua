--Final Light
--Script by JoyJ and mercury233
function c101007090.initial_effect(c)
	--activate
	local e1 = Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101007090+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101007090.condition)
	e1:SetCost(c101007090.cost)
	e1:SetTarget(c101007090.target)
	e1:SetOperation(c101007090.operation)
	c:RegisterEffect(e1)
end
function c101007090.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,EFFECT_LPCOST_CHANGE)
end
function c101007090.spfilter(c,e,tp)
	return c:IsSetCard(0x122) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCanBeEffectTarget(e)
end
function c101007090.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		e:SetLabel(100)
		return true
	end
end
function c101007090.check(g)
	return g:GetClassCount(Card.GetCode)==#g
end
function c101007090.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(c101007090.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chkc then return false end
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return ft>0 and g:GetCount()>0 and Duel.CheckLPCost(tp,1000)
	end
	e:SetLabel(0)
	local ct=math.min(g:GetClassCount(Card.GetCode),ft)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then
		ct=1
	end
	local pay_list = {}
	for p=1,ct do
		if Duel.CheckLPCost(tp,1000*p) then table.insert(pay_list,p) end
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101007090,0))
	local pay=Duel.AnnounceNumber(tp,table.unpack(pay_list))
	Duel.PayLPCost(tp,pay*1000)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,c101007090.check,false,pay,pay)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,sg:GetCount(),0,0)
end
function c101007090.spfilter2(c,e,tp)
	return c:IsAttackBelow(2000) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101007090.operation(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if sg:GetCount()>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		sg=sg:Select(tp,ft,ft,nil)
	end
	local ct=Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	if ct<=0 then return end
	local g2=Duel.GetMatchingGroup(c101007090.spfilter2,tp,0,LOCATION_GRAVE,nil,e,1-tp)
	local ct2=math.min(Duel.GetLocationCount(1-tp,LOCATION_MZONE),ct)
	if g2:GetCount()>0 and ct2>0
		and Duel.SelectYesNo(1-tp,aux.Stringid(101007090,1)) then
		if Duel.IsPlayerAffectedByEffect(1-tp,59822133) then ct2=1 end
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
		sg=g2:Select(1-tp,1,ct2,nil)
		Duel.SpecialSummon(sg,0,1-tp,1-tp,false,false,POS_FACEUP)
	end
end
