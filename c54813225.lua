--ダックファイター
---@param c Card
function c54813225.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(54813225,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,54813225)
	e1:SetCost(c54813225.spcost)
	e1:SetTarget(c54813225.sptg)
	e1:SetOperation(c54813225.spop)
	c:RegisterEffect(e1)
end
function c54813225.relgoal(sg,tp)
	Duel.SetSelectedCard(sg)
	return sg:CheckWithSumGreater(Card.GetLevel,3) and aux.mzctcheckrel(sg,tp)
end
function c54813225.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetReleaseGroup(tp):Filter(Card.IsType,nil,TYPE_TOKEN)
	if chk==0 then return mg:CheckSubGroup(c54813225.relgoal,1,3,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=mg:SelectSubGroup(tp,c54813225.relgoal,false,1,3,tp)
	aux.UseExtraReleaseCount(sg,tp)
	Duel.Release(sg,REASON_COST)
end
function c54813225.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c54813225.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
