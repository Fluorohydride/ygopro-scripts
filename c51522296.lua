--凶導の白き天底
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(s.splimit)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x145))
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)
	--opponent applies effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOEXTRA)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id)
	e3:SetTarget(s.target)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)
end
function s.splimit(e,se,sp,st)
	return st&SUMMON_TYPE_RITUAL~=SUMMON_TYPE_RITUAL or (se and se:GetHandler():IsSetCard(0x145))
end
function s.efilter(e,re)
	return re:GetOwnerPlayer()~=e:GetOwnerPlayer() and re:IsActivated()
		and re:IsActiveType(TYPE_MONSTER) and re:IsActiveType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK)
end
function s.tefilter(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)
	local g=Duel.GetMatchingGroup(s.tefilter,tp,0,LOCATION_MZONE,nil)
	local b1=ct>=2 and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_HAND+LOCATION_EXTRA,math.floor(ct/2),nil)
	local b2=#g>0 and not g:IsExists(aux.NOT(Card.IsAbleToExtra),1,nil)
	if chk==0 then return b1 or b2 end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)
	local halfct=math.floor(ct/2)
	local g=Duel.GetMatchingGroup(s.tefilter,tp,0,LOCATION_MZONE,nil)
	local b1=ct>=2 and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_HAND+LOCATION_EXTRA,halfct,nil)
	local b2=#g>0 and not g:IsExists(aux.NOT(Card.IsAbleToExtra),1,nil)
	if not b1 and not b2 then return end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(id,1)
		opval[off]=0
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(id,2)
		opval[off]=1
		off=off+1
	end
	local op=Duel.SelectOption(1-tp,table.unpack(ops))+1
	local sel=opval[op]
	if sel==0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(1-tp,Card.IsAbleToGrave,tp,0,LOCATION_HAND+LOCATION_EXTRA,halfct,halfct,nil)
		if #g>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	elseif sel==1 then
		Duel.SendtoDeck(g:Filter(Card.IsAbleToExtra,nil),nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
