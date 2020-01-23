--ノクトビジョン・ドラゴン
function c70333910.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(70333910,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,70333910)
	e1:SetCondition(c70333910.spcon)
	e1:SetTarget(c70333910.sptg)
	e1:SetOperation(c70333910.spop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(70333910,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCountLimit(1,70333911)
	e2:SetCondition(c70333910.drcon)
	e2:SetTarget(c70333910.drtg)
	e2:SetOperation(c70333910.drop)
	c:RegisterEffect(e2)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(70333910,2))
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c70333910.discon)
	e3:SetCost(aux.bfgcost)
	e3:SetOperation(c70333910.disop)
	c:RegisterEffect(e3)
end
function c70333910.spfilter(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsControler(tp)
end
function c70333910.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c70333910.spfilter,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function c70333910.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c70333910.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c70333910.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_LINK
end
function c70333910.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c70333910.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c70333910.tfilter(c,tp)
	return c:IsOnField() and c:IsControler(tp) and c:IsFacedown()
end
function c70333910.discon(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsExists(c70333910.tfilter,1,nil,tp) and Duel.IsChainDisablable(ev)
end
function c70333910.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):Filter(Card.IsFacedown,nil):Filter(Card.IsRelateToEffect,nil,re)
	local tc=tg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
		e1:SetValue(c70333910.tgoval)
		e1:SetCondition(c70333910.tgocon)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetOwnerPlayer(tp)
		tc:RegisterEffect(e1)
		tc=tg:GetNext()
	end
end
function c70333910.tgoval(e,re,rp)
	return rp==1-e:GetOwnerPlayer()
end
function c70333910.tgocon(e)
	return e:GetHandler():IsFacedown()
end
