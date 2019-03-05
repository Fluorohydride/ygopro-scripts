--ウィッチクラフト・マスターピース
function c55072170.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,55072170)
	e1:SetCondition(c55072170.condition)
	e1:SetTarget(c55072170.target)
	e1:SetOperation(c55072170.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(55072170,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,55072171)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c55072170.spcost)
	e2:SetTarget(c55072170.sptg)
	e2:SetOperation(c55072170.spop)
	c:RegisterEffect(e2)
end
function c55072170.rccfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x128)
end
function c55072170.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c55072170.rccfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c55072170.filter(c,tp)
	return c:IsType(TYPE_SPELL) and Duel.IsExistingMatchingCard(c55072170.filter2,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c55072170.filter2(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function c55072170.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c55072170.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c55072170.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(55072170,0))
	Duel.SelectTarget(tp,c55072170.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c55072170.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c55072170.filter2,tp,LOCATION_DECK,0,1,1,nil,tc:GetOriginalCode())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c55072170.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c55072170.cfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost()
end
function c55072170.spfilter(c,e,tp,lv)
	return c:IsSetCard(0x128) and c:IsLevelBelow(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c55072170.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		local cg=Duel.GetMatchingGroup(c55072170.cfilter,tp,LOCATION_GRAVE,0,nil)
		return c:IsAbleToRemoveAsCost()
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c55072170.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,cg:GetCount())
	end
	local cg=Duel.GetMatchingGroup(c55072170.cfilter,tp,LOCATION_GRAVE,0,nil)
	local tg=Duel.GetMatchingGroup(c55072170.spfilter,tp,LOCATION_DECK,0,nil,e,tp,cg:GetCount())
	local lvt={}
	local tc=tg:GetFirst()
	while tc do
		local tlv=0
		tlv=tlv+tc:GetLevel()
		lvt[tlv]=tlv
		tc=tg:GetNext()
	end
	local pc=1
	for i=1,12 do
		if lvt[i] then lvt[i]=nil lvt[pc]=i pc=pc+1 end
	end
	lvt[pc]=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(55072170,2))
	local lv=Duel.AnnounceNumber(tp,table.unpack(lvt))
	local rg1=Group.CreateGroup()
	if lv>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg2=cg:Select(tp,lv,lv,c)
		rg1:Merge(rg2)
	end
	rg1:AddCard(c)
	Duel.Remove(rg1,POS_FACEUP,REASON_COST)
	e:SetLabel(lv)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c55072170.sfilter(c,e,tp,lv)
	return c:IsSetCard(0x128) and c:IsLevel(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c55072170.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c55072170.sfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,lv)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
