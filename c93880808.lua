--アルカナ トライアンフジョーカー
function c93880808.initial_effect(c)
	aux.AddCodeList(c,25652259,64788463,90876561)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(93880808,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCost(c93880808.spcost)
	e1:SetTarget(c93880808.sptg)
	e1:SetOperation(c93880808.spop)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c93880808.atkval)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(93880808,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c93880808.descost)
	e3:SetTarget(c93880808.destg)
	e3:SetOperation(c93880808.desop)
	c:RegisterEffect(e3)
end
c93880808.tgchecks=aux.CreateChecks(Card.IsCode,{25652259,64788463,90876561})
function c93880808.cfilter(c)
	return c:IsCode(25652259,64788463,90876561) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsAbleToGraveAsCost()
end
function c93880808.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c93880808.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	if chk==0 then return g:CheckSubGroupEach(c93880808.tgchecks,aux.mzctcheck,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroupEach(tp,c93880808.tgchecks,false,aux.mzctcheck,tp)
	Duel.SendtoGrave(sg,REASON_COST)
end
function c93880808.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c93880808.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c93880808.atkval(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_HAND,LOCATION_HAND)*500
end
function c93880808.descostfilter(c,tp)
	local type=bit.band(c:GetType(),0x7)
	return c:IsDiscardable() and Duel.IsExistingMatchingCard(c93880808.desfilter,tp,0,LOCATION_ONFIELD,1,nil,type)
end
function c93880808.desfilter(c,type)
	return c:IsType(type) and c:IsFaceup()
end
function c93880808.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		e:SetLabel(100)
		return Duel.IsExistingMatchingCard(c93880808.descostfilter,tp,LOCATION_HAND,0,1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local cost=Duel.SelectMatchingCard(tp,c93880808.descostfilter,tp,LOCATION_HAND,0,1,1,nil,tp):GetFirst()
	e:SetLabel(bit.band(cost:GetType(),0x7))
	Duel.SendtoGrave(cost,REASON_COST+REASON_DISCARD)
end
function c93880808.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return true
	end
	local type=e:GetLabel()
	local g=Duel.GetMatchingGroup(c93880808.desfilter,tp,0,LOCATION_ONFIELD,nil,type)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function c93880808.desop(e,tp,eg,ep,ev,re,r,rp)
	local type=e:GetLabel()
	local g=Duel.GetMatchingGroup(c93880808.desfilter,tp,0,LOCATION_ONFIELD,nil,type)
	if #g>0 then Duel.Destroy(g,REASON_EFFECT) end
end
