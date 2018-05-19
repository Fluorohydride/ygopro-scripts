--ショートヴァレル・ドラゴン
function c73341839.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x102),2,2)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(73341839,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,73341839)
	e1:SetCondition(c73341839.spcon)
	e1:SetCost(c73341839.spcost)
	e1:SetTarget(c73341839.sptg)
	e1:SetOperation(c73341839.spop)
	c:RegisterEffect(e1)
end
function c73341839.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x10f) and c:IsType(TYPE_LINK)
end
function c73341839.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c73341839.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c73341839.costfilter(c,tp)
	return c:IsLinkBelow(3) and Duel.GetMZoneCount(tp,c)>0
end
function c73341839.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c73341839.costfilter,1,nil,tp) end
	local sg=Duel.SelectReleaseGroup(tp,c73341839.costfilter,1,1,nil,tp)
	e:SetLabel(sg:GetFirst():GetLink())
	Duel.Release(sg,REASON_COST)
end
function c73341839.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c73341839.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetTarget(c73341839.lklimit)
		e1:SetLabel(e:GetLabel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end
function c73341839.lklimit(e,c)
	if not c then return false end
	local lk=e:GetLabel()
	return c:IsLink(lk)
end
