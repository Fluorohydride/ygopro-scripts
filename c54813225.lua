--ダックファイター
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
function c54813225.relrec(c,tp,sg,mg)
	sg:AddCard(c)
	local res=c54813225.relgoal(tp,sg) or mg:IsExists(c54813225.relrec,1,sg,tp,sg,mg)
	sg:RemoveCard(c)
	return res
end
function c54813225.relgoal(tp,sg)
	Duel.SetSelectedCard(sg)
	if sg:CheckWithSumGreater(Card.GetLevel,3) and Duel.GetMZoneCount(tp,sg)>0 then
		Duel.SetSelectedCard(sg)
		return Duel.CheckReleaseGroup(tp,nil,0,nil)
	else return false end
end
function c54813225.relfilter(c,g)
	return g:IsContains(c)
end
function c54813225.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetReleaseGroup(tp):Filter(Card.IsType,nil,TYPE_TOKEN)
	local sg=Group.CreateGroup()
	if chk==0 then return mg:IsExists(c54813225.relrec,1,nil,tp,sg,mg) end
	repeat
		local cg=mg:Filter(c54813225.relrec,sg,tp,sg,mg)
		local g=Duel.SelectReleaseGroup(tp,c54813225.relfilter,1,1,nil,cg)
		sg:Merge(g)
	until c54813225.relgoal(tp,sg)
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
