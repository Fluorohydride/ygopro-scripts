--コクーン・リボーン
function c43644025.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(43644025,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(c43644025.cost)
	e2:SetTarget(c43644025.target)
	e2:SetOperation(c43644025.activate)
	c:RegisterEffect(e2)
end
function c43644025.filter1(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x1e) and Duel.IsExistingTarget(c43644025.filter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,c,e,tp)
end
function c43644025.filter2(c,mc,e,tp)
	return c:IsSetCard(0x1f) and aux.IsCodeListed(mc,c:GetCode()) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c43644025.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c43644025.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then
		local res=e:GetLabel()==1
		e:SetLabel(0)
		return res and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
			and Duel.CheckReleaseGroup(tp,c43644025.filter1,1,nil,e,tp) end
	e:SetLabel(0)
	local rg=Duel.SelectReleaseGroup(tp,c43644025.filter1,1,1,nil,e,tp)
	Duel.Release(rg,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c43644025.filter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,rg:GetFirst(),e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c43644025.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
