--影六武衆－ドウジ
function c70180284.initial_effect(c)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(70180284,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c70180284.tgcon)
	e1:SetTarget(c70180284.tgtg)
	e1:SetOperation(c70180284.tgop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTarget(c70180284.reptg)
	e3:SetValue(c70180284.repval)
	e3:SetOperation(c70180284.repop)
	c:RegisterEffect(e3)
end
function c70180284.tgcfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x3d) and c:IsControler(tp)
end
function c70180284.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(c70180284.tgcfilter,1,e:GetHandler(),tp)
end
function c70180284.tgfilter(c)
	return c:IsSetCard(0x3d) and c:IsAbleToGrave()
end
function c70180284.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c70180284.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c70180284.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c70180284.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c70180284.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x3d)
		and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c70180284.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c70180284.repfilter,1,nil,tp)
		and eg:GetCount()==1 end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c70180284.repval(e,c)
	return c70180284.repfilter(c,e:GetHandlerPlayer())
end
function c70180284.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
