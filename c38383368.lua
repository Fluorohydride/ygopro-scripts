--エキストラケアトップス
function c38383368.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(38383368,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,38383368)
	e1:SetTarget(c38383368.sptg)
	e1:SetOperation(c38383368.spop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c38383368.drcon)
	e2:SetTarget(c38383368.drtg)
	e2:SetOperation(c38383368.drop)
	c:RegisterEffect(e2)
end
function c38383368.cfilter(c)
	if not (c:IsReason(REASON_BATTLE) and c:GetPreviousSequence()>5) then return false end
	local d=c:GetBattleTarget()
	return d:IsRelateToBattle() and d:GetSequence()<=5 or not d:IsRelateToBattle() and d:GetPreviousSequence()<=5
end
function c38383368.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:Filter(c38383368.cfilter,nil):GetFirst()
	if chk==0 then return tc and Duel.GetLocationCount(tc:GetControler(),LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) end
	e:SetLabel(tc:GetControler())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c38383368.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,1,tp,e:GetLabel(),false,false,POS_FACEUP_DEFENSE)
	end
end
function c38383368.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY) and c:GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c38383368.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c38383368.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
