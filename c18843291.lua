--ライトロード・アテナ ミネルバ
local s,id,o=GetID()
function s.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.tgcon)
	e1:SetTarget(s.tgtg)
	e1:SetOperation(s.tgop)
	c:RegisterEffect(e1)
	--cannot remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_REMOVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,1)
	e2:SetTarget(s.efilter)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(s.eftg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--remove and tograve
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DECKDES)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,id+o)
	e4:SetCost(s.recost)
	e4:SetTarget(s.retg)
	e4:SetOperation(s.reop)
	c:RegisterEffect(e4)
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function s.tgfilter(c)
	return c:IsSetCard(0x38) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():GetMaterial():FilterCount(Card.IsSetCard,nil,0x38)>0 and Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,tp,LOCATION_DECK)
end
function s.fselect(g)
	return g:GetClassCount(Card.GetRace)==g:GetCount()
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local mc=e:GetHandler():GetMaterial():FilterCount(Card.IsSetCard,nil,0x38)
	local g=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and mc>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		Duel.SendtoGrave(g:SelectSubGroup(tp,s.fselect,false,1,mc),REASON_EFFECT)
	end
end
function s.efilter(e,c,rp,r,re)
	return c==e:GetHandler() and r&REASON_EFFECT>0
end
function s.eftg(e,c)
	return c:IsSetCard(0x38) and c:IsFaceup()
end
function s.refilter(c)
	return c:IsSetCard(0x38) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function s.recost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function s.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	local dc=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsPlayerCanDiscardDeck(tp,1) and Duel.IsExistingMatchingCard(s.refilter,tp,LOCATION_GRAVE,0,1,nil) and dc>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local cg=Duel.SelectMatchingCard(tp,s.refilter,tp,LOCATION_GRAVE,0,1,math.min(dc,4),nil)
	e:SetLabel(0,cg:GetCount())
	Duel.Remove(cg,POS_FACEUP,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,cg:GetCount())
end
function s.reop(e,tp,eg,ep,ev,re,r,rp)
	local label,count=e:GetLabel()
	Duel.DiscardDeck(tp,count,REASON_EFFECT)
end
