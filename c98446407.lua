--ネフティスの導き手
---@param c Card
function c98446407.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98446407,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c98446407.spcost)
	e1:SetTarget(c98446407.sptg)
	e1:SetOperation(c98446407.spop)
	c:RegisterEffect(e1)
end
function c98446407.mzfilter(c,tp)
	return c:IsControler(tp) and c:GetSequence()<5
end
function c98446407.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if c:GetSequence()<5 then ft=ft+1 end
	if chk==0 then return ft>-1 and c:IsReleasable() and Duel.CheckReleaseGroup(tp,nil,1,c)
		and (ft>0 or Duel.CheckReleaseGroup(tp,c98446407.mzfilter,1,c,tp)) end
	local rg=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	if ft>0 then
		rg=Duel.SelectReleaseGroup(tp,nil,1,1,c)
	else
		rg=Duel.SelectReleaseGroup(tp,c98446407.mzfilter,1,1,c,tp)
	end
	rg:AddCard(c)
	Duel.Release(rg,REASON_COST)
end
function c98446407.filter(c,e,tp)
	return c:IsCode(61441708) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98446407.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98446407.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c98446407.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98446407.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
